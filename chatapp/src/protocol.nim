import json
type
    Message* = object
        username* :string
        message* :string

proc parseMessage*(data: string): Message =
    let dataJason = parseJson(data)
    result.username = dataJason["username"].getStr()
    result.message = dataJason["message"].getStr()

proc createMessage*(username,message:string):string =
    result = $(%{
        "username": %username,
        "message": %message
    }) & "\c\l"


when isMainModule:
    block:
        let data = """{"username":"John","message":"Hi!"}"""
        let parsed = parseMessage(data)

        doAssert parsed.username == "John"
        doAssert parsed.message == "Hi!"
        echo("All tests passed!")
    block:
        let data = """foobar"""
        try:
            let parsed = parseMessage(data)
            doAssert false
        except JsonParsingError:
            doAssert true
        except:
            doAssert false
    block:
        let expected = """{"username":"jack","message":"hello"}""" & "\c\l"
        doAssert createMessage("jack","hello")


        
        
