using EzXML
using JSON

const DOI = "10.21105"
const DIR = "proceedings-papers"

function main()

    papers = readdir(DIR)
    filter!(s->startswith(s, "jcon"), papers)

    @info "Found papers" N=length(papers)

    result = Dict{String, Any}()

    for paper in papers
        path = joinpath(DIR, paper, join([DOI, paper, "crossref.xml"],"."))

        if !isfile(path)
            @error "XML does not exist for" paper path
        end

        xml = nothing
        try
            xml = readxml(path)
        catch
            @error "Couldn't parse XML for" paper path
        end
        xml === nothing && continue
        doc = root(xml)

        ns = namespace(doc)
        articles = findall("//x:journal_article", doc, ["x" => ns])

        if length(articles) != 1
            @error "Expected one article, found" N=length(articles)
            continue
        end
        article = articles[1]

        article = convert_article(article)
        article[:DOI] = joinpath(DOI, paper)
        result[paper] = article
    end

    open("workspace/data/papers.json", "w") do io
        JSON.print(io, result, 2)
    end
end

function convert_article(article)
    ns = ["x" => namespace(article)]
    authors = map(findall("//x:person_name", article, ns)) do author
        Dict(
            :order => author["sequence"],
            :role  => author["contributor_role"],
            :surname => nodecontent(findfirst("//x:surname/text()", author, ns)),
            :givenname => nodecontent(findfirst("//x:given_name/text()", author,  ns)),
            :ORCID => nodecontent(findfirst("//x:ORCID/text()", author, ns))
        )
    end

    Dict(
        :title => nodecontent(findfirst("//x:title/text()", article, ns)),
        :authors => authors,
    )
end

if !Base.isinteractive()
    main()
end

