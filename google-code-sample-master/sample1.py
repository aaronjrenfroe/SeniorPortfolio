from itertools import permutations
import datetime

def getTime(time_str):
  return datetime.datetime.strptime(time_str, '%H:%M')

S = '11:00'

digits = [val for val in S if val != ':']

shortest = None
length = 24*60*60


give_time = getTime(S)

for perm in permutations(digits,4):
  hours = int(perm[0]+perm[1])
  minutes = int(perm[2]+perm[3])
  if hours > 23 or minutes > 59:
    continue

  time_str = perm[0]+perm[1]+':'+perm[2]+perm[3]
  if time_str == S:
    continue
  time = getTime(time_str)
  perm_length = (time - give_time ).total_seconds()

  if perm_length < 0:
    perm_length = 24*60*60 - perm_length

  if(perm_length % 24*60*60  < length):
    length = perm_length
    shortest = time_str

if shortest is None:
  print(S)
else:
  print(shortest)

