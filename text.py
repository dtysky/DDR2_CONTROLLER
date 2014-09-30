import random

fdo=open('./textfile_r.dat','w')
fto=open('./textfile_st.dat','w')

sdo=""
sto=""

for index in range (10):
	#state
	#bank
	tmp=bin(random.randint(0,7))[2:]
	if len(tmp)<3:
		for j in range(3-len(tmp)):
			sto+="0";
		sto+=tmp+'\n';
	else:
		sto+=(tmp+'\n')
	tmp=bin(random.randint(0,1023))[2:]
	if len(tmp)<10:
		for j in range(10-len(tmp)):
			sto+="0";
		sto+=tmp+'\n';
	else:
		sto+=(tmp+'\n')
	tmp=bin(random.randint(0,8191))[2:]
	if len(tmp)<13:
		for j in range(13-len(tmp)):
			sto+="0";
		sto+=tmp+'\n';
	else:
		sto+=(tmp+'\n')
	#data
	for i in range(512):
		tmp=bin(random.randint(0,65534))[2:]
		if len(tmp)<16:
			for j in range(16-len(tmp)):
				sdo+="0";
			sdo+=tmp+'\n';
		else:
			sdo+=(tmp+'\n')
	#the end of one frame
	sdo+="1111111111111111\n"

fto.write(sto)
fto.flush()
fto.close()
fdo.write(sdo)
fdo.flush()
fdo.close()