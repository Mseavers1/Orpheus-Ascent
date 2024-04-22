import json

## Use https://beautifier.io/ to turn file into multi line ##

# Loading data from https://stackoverflow.com/questions/20199126/reading-json-from-a-file
with open('../Csc-275-project/jsons/platforms.json') as f:
    d = json.load(f)

sorted_data_values = ({k: v for k, v in sorted(d.items(), key=lambda item: item[1]["Size"])})

dic = {}

num = 0
for x in sorted_data_values:
    dic[str(num)] = sorted_data_values[x]
    num += 1

with open('new_states.json', 'w') as f:
    json.dump(dic, f)
