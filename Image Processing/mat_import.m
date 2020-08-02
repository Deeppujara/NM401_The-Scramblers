function [y] = mat_import()
ls
tx=input("1 = enter filename / folder\n2 = Type - to go back\n",'s');
flag=0;
current=pwd;
while flag>=0
  if tx=="-"
      cd ../;
      flag=1;
  elseif isfolder(tx)
      cd(tx);
      flag=1;
  elseif isfile(tx)
        y=importdata(tx);;
      break;
  end
  ls;
  tx=input("1 = enter filename / folder\n2 = Type - to go back\n",'s');
end
if flag==1
    cd(current);
end
end