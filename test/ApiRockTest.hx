package ;

import apirock.ApiRock;

class ApiRockTest {
    
    static public function main() {
        
        var apirock:ApiRock = new ApiRock("Postman Echo");

        // GET GET Request
        apirock.makeRequest('Get a simple request')
            .GETting('https://postman-echo.com/get?x=0')
            .sendingQueryStringData('foo', 'bar')
            .sendingQueryStringData('foo', 'far')
            .sendingQueryStringData('hey', 'you')
            .mustPass()
            .makeDataAsserts({args:{foo:['bar','far'], hey:'you', x:'0'}})
        .then()

        // .makeRequest('Send json data')
        //     .POSTing('https://postman-echo.com/post')
        //     .sendingQueryStringData('foo', 'bar')
        //     .sendingJsonData(haxe.Json.stringify({foo:'bar'}))
        //     .mustPass()
        //     .makeDataAsserts({args:{foo:'bar'},json:{foo:'bar'}})
        // .then()

        .makeRequest('Send complex json data')
            .POSTing('https://postman-echo.com/post')
            .sendingJsonData(haxe.Json.stringify(
                {
                    "name" : "John Smith",
                    "age" : 37,
                    "cars": [
                        { "name" : "Ford", 
                            "models" : [
                                {"name":"Fiesta", "colors":["Pearl", "Silver"]},
                                {"name":"Focus", "colors":["Blue", "Black"]},
                                {"name":"Mustang", "colors":["Silver", "Blue"]}
                            ]
                        },
                        { "name" : "BMW", 
                            "models" : [
                                {"name":"320", "colors":["Bright Yellow"]},
                                {"name":"X3", "colors":["Titan Silver"]},
                                {"name":"X5", "colors":["Black", "Beige"]}
                            ]
                        },
                        { "name" : "Fiat", 
                            "models" : [
                                {"name": "500", "colors" : ["Bianco", "Rosso"]}, 
                                {"name" : "Panda", "colors" : ["Bianco", "Ivory"]}
                            ]
                        }
                    ]
                }
            ))
            .mustPass()
            .makeDataAsserts(
                {
                    json : {
                        age : 37,
                        name : "John Smith",
                        "cars[1]" : {"name":"BMW"},
                        "cars[0]" : {"models[0]" : {"name": "Fiesta"}},
                        "cars[?]" : {"models[?]": {"colors[1]":"Ivory"}},
                        "cars[?]" : {"name":"Fiat"}
                    }
                }
            )
        .then()

        .makeRequest('Send form data')
            .POSTing('https://postman-echo.com/post')
            .sendingFormData('field_1', 'value_1')
            .sendingFormData('field_2', 'value_2')
            .sendingFormData('field_arr', '1')
            .sendingFormData('field_arr', '2')
            .mustPass()
            .makeDataAsserts({form:{field_1:'value_1', field_2:'value_2', 'field_arr[]':['1', '2']}})
        .then()
        
        .makeRequest('Send raw data')
            .POSTing('https://postman-echo.com/post')
            .sendingRawData('raw data')
            .mustPass()
            .makeDataAsserts({data:'raw data'})
        .then()
        
        .makeRequest('Testing put method')
            .PUTting('https://postman-echo.com/put')
            .mustPass()
            .makeDataAsserts({data:''})
        .then()

        .makeRequest('Testing patch method')
            .PATCHing('https://postman-echo.com/patch')
            .mustPass()
            .makeDataAsserts({data:''})
        .then()
    
        .makeRequest('Testing delete method')
            .DELETing('https://postman-echo.com/delete')
            .mustPass()
            .makeDataAsserts({data:''})
        .then()
        
        .makeRequest('Testing sending headers')
            .GETting('https://postman-echo.com/headers')
            .sendingHeader('my-header', 'header value')
            .mustPass()
            .makeDataAsserts({headers:{'my-header': 'header value'}})
        .then()

        .makeRequest('Testing received headers')
            .GETting('https://postman-echo.com/response-headers')
            .sendingQueryStringData('foo', 'bar')
            .mustPass()
            .makeHeadAsserts({foo:'bar', 'content-type':'application/json; charset=utf-8'})
        .then()

        .makeRequest('Failing a basic authentication')
            .GETting('https://postman-echo.com/basic-auth')
            .sendingBasicAUTH('wrong_user', 'wrong_password')
            .mustFail()
            .makeDataAsserts('Unauthorized')
        .then()

        .makeRequest('Testing basic authentication')
            .GETting('https://postman-echo.com/basic-auth')
            .sendingBasicAUTH('postman', 'password')
            .mustPass()
            .makeDataAsserts({authenticated:true})
        .then()

        .makeRequest('Testing status code SUCCESS')
            .GETting('https://postman-echo.com/status/200')
            .mustPass()
        .then()

        .makeRequest('Testing status code FAIL')
            .GETting('https://postman-echo.com/status/300')
            .mustFail()
        .then()

        .makeRequest('Testing specific status code')
            .GETting('https://postman-echo.com/status/502')
            .mustDoCode(502)
        .then()

        .runTests();

    }

}