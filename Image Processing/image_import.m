function [y] = image_import()
ls
tx=input("1 = enter filename / folder\n2 = Type - to go back\n3 = Type cam to Capture the Image from Webcam\n",'s');
flag=0;
current=pwd;
while flag>=0
  if tx=="-"
      cd ../;
      flag=1;
  elseif tx=="cam"
      cam=webcam;
      y=snapshot(cam);
      clear cam;
      break;
  elseif isfolder(tx)
      cd(tx);
      flag=1;
  elseif isfile(tx)
        y=imread(tx);
      break;
  end
  ls;
  tx=input("1 = enter filename / folder\n2 = Type - to go back\n3 = Type cam to Capture the Image from Webcam\n",'s');
end
if flag==1
    cd(current);
end
end