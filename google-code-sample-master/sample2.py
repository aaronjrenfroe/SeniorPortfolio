# Aaron Renfroe
# Shorter solution
# least mental complexity
# slower becsue of string manipulaiton
def solution(P, K):
    # write your code in Python 3.6
    # P is list
    # K is number of groups
    if(K > (len(P) / 2) + 1):
        return -1

    if(K == 0):
        return 0

    bed = ['.'] * len(P) 
    
    for i, val in enumerate(P):
        bed[val - 1] = '1'
        bed_str = ''.join(bed)
        
        bed_str = [lst for lst in bed_str.split('.') if len(lst) > 0]
        
        if len(bed_str) == K:

            return i + 1

    return -1



# Faster Solutions
# These Solutions are My Own

# Returns Step when group count == K
# When starting with a full array and removing and element
# [1, 1, 1, 1, 1] => [1,1,1,0,1] 
def count_groups_reversed(P, K):

    if(K > (len(P) / 2) + 1):
        return -1

    if(K == 0):
        return 0

    groups = [(min(P), max(P))]

    for step, val in enumerate(reversed(P)):
        for idx, group in enumerate(groups):
            if val >= group[0] and val <= group[1]:
                # Removing group of one
                if group[0] == val and group[1] == val:
                    groups.remove(group)
                else:
                    # Spliting a Group
                    groups.append((val + 1, group[1]))
                    groups[idx] = (group[0], val - 1)

            if(len(groups) == K):
                return len(P) - step - 1

    return -1

# Returns Step when group count == K
# When starting with an empty array and adding an element
# [0,0,0,0,0] => [0,0,1,0,0] 
def count_groups(P, K):
    #Check for edge cases
    if(K > (len(P) / 2) + 1):
        return -1

    if(K == 0):
        return 0

    if(K == 1):
        return 1
    # You can also check if the array is sorted and if K > 1
    # If array is sorted you will never have more than one group

    # Going to store groups as tuples where 
    # t[0] is value starting the group
    # and t[1] is value ending the group
    groups = [(P[0],P[0])]

    for step, val in enumerate(P[1:]):

        updated = False # var to check if a condition was met in the proceding for-loop
        for idx, group in enumerate(groups):
            # if val comes right before group start
            if (val + 1) == group[0]:
                # Update Group
                groups[idx] == (val, group[1])
                updated = True
                break
            # or right after group ends
            elif (val - 1) == group[1]:
                # Update Group
                groups[idx] == (group[1], val)
                updated = True
                break
        # If 
        if(not updated):
          # Add new Group
          new_group = (val, val)
          groups.append(new_group)

        if(len(groups) == K):
          # returning step + 2 to compensate for 0 indexed and omission of first element in array from for loop
          return step + 2

    # Impossible: Array could have been semi sorted or better and
    # there want enough distrobution to create K groups
    return -1


print(solution([3,1,5,4,2], 3))
print(count_groups([3,1,5,4,2], 3))
print(count_groups_reversed([3,1,5,4,2], 3))
