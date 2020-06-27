import os , threadpool, asyncdispatch, asyncnet, protocol
proc connect(socket: AsyncSocket, serverAddr: string) {.async.} =
    echo("Connecting to ",serverAddr)
    await socket.connect(serverAddr, 7687.Port)
    echo("Connected!")

    while true:
        let line = await socket.recvLine()
        let parsed = parseMessage(line)
        echo(parsed.username, " said: ",parsed.message)

echo("chat application has started")

if paramCount() == 0:
    quit("Please specify the server address, e.g. ./client localhost")
let serverAddr = paramStr(1)

echo("Please enter your username")
let user = stdin.readLine()
var socket = newAsyncSocket()
asyncCheck connect(socket,serverAddr)
var messageFlowVar = spawn stdin.readLine()

while true:
    if messageFlowVar.isReady():
        let message = createMessage(user,^messageFlowVar)
        asyncCheck socket.send(message)
        messageFlowVar = spawn stdin.readLine()
    asyncdispatch.poll()


#echo("Connecting to ",serverAddr)



while true:
    let message = spawn stdin.readLine()
    echo("Sending \" ", ^message,"\"")
