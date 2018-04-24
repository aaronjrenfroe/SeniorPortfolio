S = '2-4A0r7-4k'
K = 3

char_list = [val for val in S if val != '-']
char_length = len(char_list)
beginging = char_length % K

dash_count = int(char_length / K)
if(beginging != 0):
  char_list.insert(beginging, '-')
offset_idx = 0 if beginging == 0 else beginging + 1

for i in range(1,dash_count):
  char_list.insert(offset_idx + (i) * K, '-')

return (''.join(char_list)