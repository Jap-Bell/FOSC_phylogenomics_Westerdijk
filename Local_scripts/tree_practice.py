#!/usr/bin/env python

from ete3 import Tree
t1 = Tree('(((a,b),c), ((e, f), g));')
t2 = Tree('(((a,c),b), ((e, f), g));')
rf, max_rf, common_leaves, parts_t1, parts_t2, disc_t1, disc_t2 = t1.robinson_foulds(t2)
print(t1.robinson_foulds(t2)[0])
print(t1, t2)
print("RF distance is %s over a total of %s" %(rf, max_rf))
print("Partitions in tree2 that were not found in tree1:", parts_t1 - parts_t2)
print("Partitions in tree1 that were not found in tree2:", parts_t2 - parts_t1)

# We can also compare trees sharing only part of their labels

#t1 = Tree('(((a,b),c), ((e, f), g));')
#t2 = Tree('(((a,c),b), (g, H));')
#rf, max_rf, common_leaves, parts_t1, parts_t2 = t1.robinson_foulds(t2)

#print t1, t2
#print "Same distance holds even for partially overlapping trees"
#print "RF distance is %s over a total of %s" %(rf, max_rf)
#print "Partitions in tree2 that were not found in tree1:", parts_t1 - parts_t2
#print "Partitions in tree1 that were not found in tree2:", parts_t2 - parts_t1
