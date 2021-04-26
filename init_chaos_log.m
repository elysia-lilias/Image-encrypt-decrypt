function idx = init_chaos_log(sized,H)

 
%map result H into 8 decimal number between 0 and 1
dech = hex2dec(H)/5000000000;




log_u =vpa( 3.6+ 0.4*dech(1),3);
log_x0 = vpa(dech(2),3);
if(log_x0 == 0)
    log_x0 = 0.1;
end



x = log_x0;
waitb = waitbar(0,'please wait');

%preprocessing

tots = 10*ceil(log10(prod(sized)));
for i=1:200
    str=['chaos initialing...',num2str(i/(200+tots)*100),'%'];
    waitbar((i)/(200+tots),waitb, str)
    x = log_u*x*(1-x);
end

ind = zeros(10,tots/10);
ind(1) = log_u*x*(1-x);
for i=2:tots
    str=['chaos initialing...',num2str((i+200)/(200+tots)*100),'%'];
    waitbar((i+200)/(200+tots),waitb, str)
    x = log_u*x*(1-x);
    ind(i) = x;
end
close(waitb)
 [out,idx] = sort(ind);
 
end
 

