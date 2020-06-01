import Vapor
import FluentMySQL

final class ArticleController: RouteCollection {
    func boot(router: Router) throws {
        let group = router.grouped("article")
    
        // post
        group.post(ArticleContainer.self, at: "create", use: create)
        // get
        group.get("all", use: getAllArticle)
        group.get("reverse", use: getAllreveseArticle)
        group.get("id", use: getArticle)
        
        // delete

        
        // put
        
        
    }
}


extension ArticleController {
    
    private func create(_ req: Request, container: ArticleContainer) throws -> Future<Response>{
        
        guard let article: Article = Article(id: nil,
                          title: container.title,
                          content: container.content) else {
                            return try ResponseJSON<Empty>(status: .error,
                                                           message: "저장에 실패했습니다.")
                                                           .encode(for: req)
        }
        
        return (article
               .save(on: req)
               .flatMap({ result in
                
                return try ResponseJSON<Empty>(status: .ok,
                                           message: "저장에 성공했습니다")
                                           .encode(for: req)
            
               }))
        
    }
    
    private func getAllArticle(_ req: Request) throws -> Future<Response>{

        return Article
            .query(on: req)
            .all()
            .flatMap({ result in
                let article = result.compactMap({ list -> Article in
                    var list = list;
                    list.id = nil
                    return list
                })

            return try ResponseJSON<[Article]>
                .init(data: article)
                .encode(for: req)
        })
    }

    private func getAllreveseArticle(_ req: Request) throws -> Future<Response>{
        
        return Article
            .query(on: req)
            .sort(\.id, .descending)
            .all()
            .flatMap({ result in
            
            return try ResponseJSON<[Article]>
                .init(data: result)
                .encode(for: req)
        })
    }

    private func getArticle(_ req: Request) throws -> Future<Response>{
        
        guard let id = req.query[Int.self, at: "id"] else {
            throw Abort(.badRequest, reason: "Missing id in request")
        }
        
        return Article
            .query(on: req)
            .filter(\.id == id)
            .all()
            .flatMap({ result in

            return try ResponseJSON<[Article]>.init(data: result).encode(for: req)

        })
    }
    
    private func deleteArticle(_ req: Request) throws -> Future<Response> {
        
        guard let id = req.query[Int.self, at: "id"] else {
            throw Abort(.badRequest, reason: "Missing id in request")
        }

        return Article
            .query(on: req)
            .filter(\.id == id)
            .delete()
            .flatMap({ result in
            return try ResponseJSON<[Empty]>(status: .ok, message: "").encode(for: req)
        })
    }

    private func patchArticle(_ req: Request, container: ArticleContainer) throws -> Future<Response> {

        let article:Article = Article(id: container.id,
                                      title: container.title,
                                      content: container.content)
        
        return Article
            .query(on: req)
            .filter(\.id == container.id)
            .update(article)
            .flatMap({ result in
                
            return try ResponseJSON<Article>(data: result).encode(for: req)
        })
    }
    
    private func putArticle(_ req: Request, container: ArticleContainer) throws -> Future<Response> {

        let article:Article = Article(id: container.id,
                                      title: container.title,
                                      content: container.content)
        
        return Article
            .query(on: req)
            .filter(\.id == container.id)
            .first()
            .flatMap({ result in
                
            return try ResponseJSON<Article>(data: result).encode(for: req)
        })
    }


    
}

struct ArticleContainer : Content {

    var id: Int?
    var title: String?
    var content: String?

}
