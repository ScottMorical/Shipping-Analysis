import googlemaps, openpyxl, random

excel = openpyxl.load_workbook("C:\\Users\\Scott\\Documents\\TestData.xlsx")
sheet = excel.active

start = 1
tranid = 1
CityState = {}
ZipCode = []
Identifier = []


for cell in range(2,sheet.max_row+1):
    if sheet["B"+str(cell)].value not in Identifier:
        Identifier.append(sheet["B"+str(cell)].value)

# Assign a unique transaction id to each transaction
for cell in range(2,sheet.max_row+1):
    tranid +=1
    sheet["U"+str(cell)].value = tranid
    
    # gather the location information for google maps usage later
    if sheet["D"+str(cell)].value not in CityState:
        state = sheet["E"+str(cell)].value
        zip = sheet["F"+str(cell)].value
        CityState[sheet["D"+str(cell)].value] =  tuple((state,zip))
    if start <= len(Identifier):
        sheet["V"+str(start+1)].value = Identifier[start-1]
        start +=1

# Google Maps API Key
p = open('C:\\Users\\Scott\\Documents\\apikey.text', "r")
api_key = p.read()

Maps = googlemaps.Client(key= api_key)

Hold = {}
Shipment = {}

ShipNum = 0

print(1)
cell = 2

# Find distance and duration to location, all start in the same place
for i in CityState:
        print(i)
        Distance = Maps.directions("Shreveport, LA", f"{i}, {CityState[i]}")

        KMDistance = (Distance[0]["legs"][0]["distance"]["value"])

        HrsMinsDuration = (Distance[0]["legs"][0]["duration"]["value"])
        
        sheet["R" + str(cell)].value = i
        sheet["S"+str(cell)].value = CityState[i][0]
        sheet["T"+str(cell)].value = CityState[i][1]
        cell +=1
        Hold[i] = [float(KMDistance), round(HrsMinsDuration/3600,2)] 

        Hold[i] = [0,0]
p.close()      

# Place distance and duration info in new columns
for cell in range(2,sheet.max_row+1):
    
    sheet["O"+str(cell)].value = Hold[sheet["D"+str(cell)].value][0]
    sheet["P"+str(cell)].value = Hold[sheet["D"+str(cell)].value][1]
    
    # Assign unique Shipment ID based on tuple of location sent and date
    ShipID = (sheet["A"+str(cell)].value, sheet["B"+str(cell)].value)
    if ShipID not in Shipment:
        ShipNum +=1
        Shipment[ShipID] = ShipNum
    sheet["Q"+str(cell)].value = Shipment[ShipID]

id = 1
numship = random.randint(30,80)

ShipNums = [k for k in range(1,ShipNum+1)]
random.shuffle(ShipNums)

print(3)
# to simulate potential drivers we randomize shipments and total shipments driven by drivers
Drivers = {}
for shipnum in ShipNums:
    if id not in Drivers:
        Drivers[id] = [shipnum]
    else:
        Drivers[id].append(shipnum)
    numship -=1
    if numship == 0:
        numship = random.randint(30,80)
        id +=1

ReverseDriver = {}

for driverid in Drivers:
    for shipid in Drivers[driverid]:
        ReverseDriver[shipid] = driverid

for cell in range(2,sheet.max_row+1):
    sheet["N"+str(cell)].value = ReverseDriver[sheet["Q"+str(cell)].value]
    
    
excel.save("C:\\Users\\Scott\\Documents\\TestData.xlsx")
excel.close()
