#write to ddr2
fd_w=open('./textfile_r.dat','r').read()
#read from ddr2
fd_r=open('./textfile_st.dat','r')

test_num=1

for l in fd_w:
	if l=="1111111111111111":
		test_num+=1
	else:
		if l==fd_r.readline():
			print "Error! Test falied! Check your controller in no."+str(test_num)+'\n'
		else:
			pass

print "Test successed! This controller is perferct!"