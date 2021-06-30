import Foundation
import Alamofire

enum BaseAPIResult<T>{
    case success(result: T)
    case failure(error:APIErrors,data: Data?)
}

enum APIErrors : Error{
    case badRequest
    case forbiddenAccess
    case pageNotfound
    case invalidData
    case unauthorized
    case unknown
    case internalServerError
    case NoInternetConnection
}

typealias ApiRequestCompletionHandler = (_ result: BaseAPIResult<Data?>) -> Void


public class BaseAPIHandler : NSObject {
    var runningOperations : Int = 0
    private static var mSharedInstance : BaseAPIHandler?  = nil;
    private var baseUrl : String?
    private override init() {}
    
    public class func sharedInstance()->BaseAPIHandler {
        if(mSharedInstance == nil){
            mSharedInstance = BaseAPIHandler()
            
            //let baseUrl = Environment().configuration(PlistKey.BaseUrl)
              //  let apiVsersion = Environment().configuration(PlistKey.APIVersion)
            mSharedInstance?.baseUrl = "http://www.scrimmage.gq/"
        }
        return mSharedInstance!
    }
    
    public func getBaseUrl() ->String? {
        return baseUrl
    }
    
    public func getRunningOperationCount()->Int{
        return runningOperations
    }
    
    func requestForApi (urlString:String,method:HTTPMethod,
                        parameters: [String: String]?,headers :HTTPHeaders?, completion:@escaping ApiRequestCompletionHandler)
    {
        addToRunningOperations()
        
        let url = "\(baseUrl!)\(urlString)"
        let request = Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default,headers:headers)
        debugPrint("API :- \( url)")
         debugPrint("Param :- \(String(describing:  parameters))")
        self.fireRequest(request: request, completion: completion)
    }

    func requestForDeleteApi (urlString:String,method:HTTPMethod,
                        parameters: [String: String]?,headers :HTTPHeaders, completion:@escaping ApiRequestCompletionHandler)
    {
        addToRunningOperations()
        
        let url = "\(baseUrl!)\(urlString)"
        let request = Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.httpBody,headers:headers)
        debugPrint("API :- \( url)")
        self.fireRequest(request: request, completion: completion)
    }
    
    private func fireRequest(request : DataRequest, completion : @escaping ApiRequestCompletionHandler){
        request.responseString { (response) in
            var statusCode = response.response?.statusCode ?? 400
            if(response.response?.statusCode == nil && response.result.error?.localizedDescription != nil){
                if((response.result.error?.localizedDescription)!.contains("The Internet connection appears to be offline")){
                    statusCode = 0
                }
            }
            APIErrorHandler.checkForError(statusCode: statusCode, data: response.data)
            switch(statusCode){
            case 0:
                completion(.failure(error: APIErrors.NoInternetConnection,data: response.data))
            case 200:
                self.printValue( data: response.data!)
                completion(.success(result: response.data));
            case 401:
                completion(.failure(error: APIErrors.unauthorized,data: response.data))
            case 400:
                completion(.failure(error: APIErrors.invalidData,data: response.data))
            case 404:
                completion(.failure(error: APIErrors.pageNotfound,data: response.data))
            case 403:
                completion(.failure(error: APIErrors.forbiddenAccess,data: response.data))
            case 500:
                completion(.failure(error: APIErrors.internalServerError,data: response.data))
            default:
                completion(.failure(error: APIErrors.unknown,data: response.data))
            }
        }
    }
    
    
    func requestForCountryDetailsApi(urlString:String,method:HTTPMethod,
                        parameters: [String: String]?,headers :HTTPHeaders, completion:@escaping ApiRequestCompletionHandler)
    {
        addToRunningOperations()
        
        let url = urlString
        let response = Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default,headers:headers)
        
        debugPrint("API :- \( url)")
        // debugPrint("Param :- \(String(describing:  parameters))")
        
        response.responseString { (response) in
            let statusCode = response.response?.statusCode ?? 0
            APIErrorHandler.checkForError(statusCode: statusCode, data: response.data)
            switch(statusCode){
            case 200:
                self.printValue( data: response.data!)
                do {
                    let data = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                   // debugPrint("Response:-  \(data)")
                    //    successClosure(data as AnyObject)
                }
                catch {
                    let error = NSError.init(domain: JSON_EMPTY_DOMAIN, code: API_JSON_EMPTY_CODE, userInfo: nil);
                    //      failureClosure(error)
                }

                completion(.success(result: response.data))
            default:
                completion(.failure(error: APIErrors.unknown,data: response.data))
            }
            
          
        }
    }

    
    func printValue(data : Data){
        
        do {
            let data = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            debugPrint("Response:-  \(data)")
            
        }
        catch {
            
            
        }
    }
    
    
    private func addToRunningOperations() {
        
        runningOperations += 1;
    }
    
    private func removeFromRunningOperations() {
        
        runningOperations -= 1;
    }
}

