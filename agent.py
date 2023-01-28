import json
import random

running = True
prevState = ""

while running:
    
    try:
        state = open(r'C:\Users\ampfr\AppData\Local\TetrisML\state.json')

        #get game data from json file
        stateData = json.load(state)

        state.close()

        #check if state has been updated by tetris program
        if stateData and prevState != stateData['boardState']:
            prevState = stateData['boardState']

            #insert function call to score all states and choose best

            #for testing choose next state at random
            choice = random.randint(0, int(stateData["count"]))

            order = {
                "rotTarget" : stateData[str(choice)]["rotation"],
                "xTarget" : stateData[str(choice)]["xposition"]
            }

            orderJSON = json.dumps(order)

            print(orderJSON)

            cmd = open(r'C:\Users\ampfr\AppData\Local\TetrisML\command.json', "w")
            cmd.write(orderJSON)

            #for i in range(0,int(stateData["count"])):
                #print(str(i) + " " + str(stateData[str(i)]["xposition"]) + " " + str(stateData[str(i)]["rotation"]));
                #print(stateData[str(i)]["stateString"])
    except:

        print("waiting for state")
        

