#
# This server simulates the neccessary output from the 
# web-server on the real titan. Used for development purposes
# After building and starting the running code can be
# found at:
#
# http://127.0.0.1:8080/build/www/pages/kncminion/#/
#
# It also simulates titans on port 9001,9002 and 9003 
# to test multi-titan-monitoring

fs = require("fs")
host = "127.0.0.1"
ports = [8080,9001,9002,9003]
express = require("express")

app = express()

app.use(express.static(__dirname))

nasty_html_status_b64 = "PGRpdiBpZD0icmVzdWx0IiBjbGFzcz0ic2VjdGlvbiI+CiAgPGRpdiBjbGFzcz0iY29sIHNwYW5fNl9vZl8xMiI+CiAgICA8aDQ+TWluaW5nIFN0YXR1czwvaDQ+CiAgICA8dGFibGUgYm9yZGVyPSIxIj4KICAgICAgPHRyPjx0ZD5NaW5lciBTdGF0dXM8L3RkPjx0ZD5SdW5uaW5nIEJGR01pbmVyIChwaWQ9ZmFrZSk8L3RkPjwvdHI+CiAgICAgIDx0cj48dGQ+TGFzdCBDaGVja2VkPC90ZD48dGQ+RmFrZTwvdGQ+PC90cj4KICAgICAgPHRyPjx0ZD5BdmcuIEhhc2ggUmF0ZTwvdGQ+PHRkPkhBU0hSQVRFSEVSRSBNaC9zPC90ZD48L3RyPgogICAgICA8dHI+PHRkPldVPC90ZD48dGQ+NDwvdGQ+PC90cj4KICAgICAgPHRyPjx0ZD5EaWZmaWN1bHR5IEFjY2VwdGVkPC90ZD48dGQ+MzEyNDwvdGQ+PC90cj4KICAgIDwvdGFibGU+CiAgPC9kaXY+CiAgCiAgPGRpdiBjbGFzcz0iY29sIHNwYW5fNl9vZl8xMiI+CiAgICA8aDQ+SFcgU3RhdHVzPC9oND4KICAgIDx0YWJsZSBib3JkZXI9IjEiPjx0cj48dGggc3R5bGU9InRleHQtYWxpZ246Y2VudGVyIj5BU0lDIHNsb3Q8L3RoPjx0aCBzdHlsZT0idGV4dC1hbGlnbjpjZW50ZXIiPlRlbXBlcmF0dXJlPC90aD48dGggc3R5bGU9InRleHQtYWxpZ246Y2VudGVyIj5EQy9EQyBhdmcgdGVtcDwvdGg+PHRoIHN0eWxlPSJ0ZXh0LWFsaWduOmNlbnRlciI+Q2xvY2s8L3RoPjx0aCBzdHlsZT0idGV4dC1hbGlnbjpjZW50ZXIiPlR5cGU8L3RoPjwvdHI+PHRyPjx0ZCBzdHlsZT0idGV4dC1hbGlnbjpjZW50ZXIiPjE8L3RkPjx0ZCBzdHlsZT0idGV4dC1hbGlnbjpjZW50ZXIiPi0tLTwvdGQ+PHRkIHN0eWxlPSJ0ZXh0LWFsaWduOmNlbnRlciI+LS0tPC90ZD48dGQgc3R5bGU9InRleHQtYWxpZ246Y2VudGVyIj4tLS08L3RkPjx0ZCBzdHlsZT0idGV4dC1hbGlnbjpjZW50ZXIiPk9GRjwvdGQ+PC90cj48dHI+PHRkIHN0eWxlPSJ0ZXh0LWFsaWduOmNlbnRlciI+MjwvdGQ+PHRkIHN0eWxlPSJ0ZXh0LWFsaWduOmNlbnRlciI+NDQuNSZuYnNwOyYjeDIxMDM7PC90ZD48dGQgc3R5bGU9InRleHQtYWxpZ246Y2VudGVyIj43MC42Jm5ic3A7JiN4MjEwMzs8L3RkPjx0ZCBzdHlsZT0idGV4dC1hbGlnbjpjZW50ZXIiPjMyNSZuYnNwO01IejwvdGQ+PHRkIHN0eWxlPSJ0ZXh0LWFsaWduOmNlbnRlciI+VEk8L3RkPjwvdHI+PHRyPjx0ZCBzdHlsZT0idGV4dC1hbGlnbjpjZW50ZXIiPjM8L3RkPjx0ZCBzdHlsZT0idGV4dC1hbGlnbjpjZW50ZXIiPjQzLjUmbmJzcDsmI3gyMTAzOzwvdGQ+PHRkIHN0eWxlPSJ0ZXh0LWFsaWduOmNlbnRlciI+NzAuNCZuYnNwOyYjeDIxMDM7PC90ZD48dGQgc3R5bGU9InRleHQtYWxpZ246Y2VudGVyIj4zMjUmbmJzcDtNSHo8L3RkPjx0ZCBzdHlsZT0idGV4dC1hbGlnbjpjZW50ZXIiPlRJPC90ZD48L3RyPjx0cj48dGQgc3R5bGU9InRleHQtYWxpZ246Y2VudGVyIj40PC90ZD48dGQgc3R5bGU9InRleHQtYWxpZ246Y2VudGVyIj40NiZuYnNwOyYjeDIxMDM7PC90ZD48dGQgc3R5bGU9InRleHQtYWxpZ246Y2VudGVyIj43Mi4yJm5ic3A7JiN4MjEwMzs8L3RkPjx0ZCBzdHlsZT0idGV4dC1hbGlnbjpjZW50ZXIiPjMyNSZuYnNwO01IejwvdGQ+PHRkIHN0eWxlPSJ0ZXh0LWFsaWduOmNlbnRlciI+VEk8L3RkPjwvdHI+PHRyPjx0ZCBzdHlsZT0idGV4dC1hbGlnbjpjZW50ZXIiPjU8L3RkPjx0ZCBzdHlsZT0idGV4dC1hbGlnbjpjZW50ZXIiPi0tLTwvdGQ+PHRkIHN0eWxlPSJ0ZXh0LWFsaWduOmNlbnRlciI+LS0tPC90ZD48dGQgc3R5bGU9InRleHQtYWxpZ246Y2VudGVyIj4tLS08L3RkPjx0ZCBzdHlsZT0idGV4dC1hbGlnbjpjZW50ZXIiPk9GRjwvdGQ+PC90cj48dHI+PHRkIHN0eWxlPSJ0ZXh0LWFsaWduOmNlbnRlciI+NjwvdGQ+PHRkIHN0eWxlPSJ0ZXh0LWFsaWduOmNlbnRlciI+NDQuNSZuYnNwOyYjeDIxMDM7PC90ZD48dGQgc3R5bGU9InRleHQtYWxpZ246Y2VudGVyIj41OS43Jm5ic3A7JiN4MjEwMzs8L3RkPjx0ZCBzdHlsZT0idGV4dC1hbGlnbjpjZW50ZXIiPjMxOC43NSZuYnNwO01IejwvdGQ+PHRkIHN0eWxlPSJ0ZXh0LWFsaWduOmNlbnRlciI+VEk8L3RkPjwvdHI+PC90YWJsZT4KICA8L2Rpdj4gICAgICAgIAo8L2Rpdj4KCg=="

hello = (request,response) ->
    response.send("Hello")

random_value = (low,high,precision) ->
    value = (Math.random() * (high-low) + low)
    str = value.toFixed(precision)
    if precision == 0
        return parseInt(str)
    else
        return parseFloat(str)

generate_asic = (id,empty = false) ->
    data = {}
    for dcdc_id in [0..7]
        dcdc = "dcdc" + dcdc_id
        data[dcdc + "_Vout"] = if empty then "" else random_value(0.77,0.8,4)
        data[dcdc + "_Iout"] = if empty then "" else random_value(42,44.5,4)
        data[dcdc + "_Temp"] = if empty then "" else random_value(75,78,3)
    for die_id in [0..3]
        die = "die" + die_id
        data[die + "_Freq"] = if empty then "" else 325
        data[die + "_Voffset"] = if empty then "0.0000" else -0.0293
    data["temperature"] = if empty then "" else random_value(42,44,1)
    return data

fake_advanced_settings = (request,response) ->
    data = {
        asic_1 : generate_asic(1,true)
        asic_2 : generate_asic(2)
        asic_3 : generate_asic(3)
        asic_4 : generate_asic(4)
        asic_5 : generate_asic(5,true)
        asic_6 : generate_asic(6)
    }
    response.send(JSON.stringify(data))
        
fake_mining_stat = (request,response) ->
    nasty_html_status = (new Buffer(nasty_html_status_b64, 'base64')).toString()
    hashrate_mhs20 = random_value(320,330,3)

    response.send(nasty_html_status.replace("HASHRATEHERE",hashrate_mhs20))

bfgminer_summary = (request,response) ->
    data = {
        "STATUS": [
            {
                "STATUS": "S",
                "When": 1418206942,
                "Code": 11,
                "Msg": "Summary",
                "Description": "bfgminer 5.0.0"
            }
        ],
        "SUMMARY": [
            {
                "Elapsed": 51204,
                "MHS av": random_value(290,340,3),
                "MHS 20s": random_value(290,340,3),
                "Found Blocks": 0,
                "Getworks": 4036,
                "Accepted": random_value(1000,1040,0),
                "Rejected": random_value(10,15,0),
                "Hardware Errors": 4201,
                "Utility": 11.247,
                "Discarded": 83644,
                "Stale": 0,
                "Get Failures": 1,
                "Local Work": 201891,
                "Remote Failures": 0,
                "Network Blocks": 336,
                "Total MH": 16598236.6597,
                "Diff1 Work": 3879.74532748,
                "Work Utility": 4.546,
                "Difficulty Accepted": 3922.03125000,
                "Difficulty Rejected": 27.75000000,
                "Difficulty Stale": 0,
                "Best Share": 8955.55312030,
                "Device Hardware%": random_value(0,1,4),
                "Device Rejected%": random_value(0,1,4),
                "Pool Rejected%": random_value(0,1,4),
                "Pool Stale%": 0.0000,
                "Last getwork": 1418206938
            }
        ],
        "id": 1
    }
    response.send(JSON.stringify(data))

bfgminer_procs = (request,response) ->
    response.header("Access-Control-Allow-Origin", "*")
    data = {
        "STATUS": [
            {
                "STATUS": "S",
                "When": Math.round(Date.now() / 1000),
                "Code": 9,
                "Msg": "16 PGA(s)",
                "Description": "bfgminer 5.0.0"
            }
        ],
        "DEVS": [],
        "id": 1
    }

    for pga in [0..15]
        pga_data = {
            "PGA": pga,
            "Name": "KNC",
            "ID": 0,
            "ProcID": 0,
            "Enabled": "Y",
            "Status": "Alive",
            "Device Elapsed": 50766,
            "MHS av": random_value(18,22,3),
            "MHS 20s": random_value(18,22,3),
            "MHS rolling": random_value(18,22,3),
            "Accepted": random_value(500,550,0),
            "Rejected": random_value(0,10,0),
            "Hardware Errors": random_value(0,10,0),
            "Utility": random_value(0.7,1,3),
            "Stale": 0,
            "Last Share Pool": 0,
            "Last Share Time": 1418206480,
            "Total MH": 1117597.4666,
            "Diff1 Work": 261.23138800,
            "Work Utility": random_value(0.1,1,3),
            "Difficulty Accepted": 255.19140625,
            "Difficulty Rejected": 2.50000000,
            "Difficulty Stale": 0,
            "Last Share Difficulty": 0.50000000,
            "Last Valid Work": 1418206517,
            "Device Hardware%": random_value(0,1,4),
            "Device Rejected%": random_value(0,1,4),
        }
        data.DEVS.push(pga_data)
    
    response.send(JSON.stringify(data))


app.post("/cgi-bin/fetch_advanced_settings.cgi",fake_advanced_settings)
app.get("/cgi-bin/fetch_mining_stat.cgi",fake_mining_stat)
app.get("/cgi-bin/bfgminer_summary.cgi",bfgminer_summary)
app.get("/cgi-bin/bfgminer_procs.cgi",bfgminer_procs)

for port in ports
    console.log("Listening on port " + port)
    app.listen(port,host)