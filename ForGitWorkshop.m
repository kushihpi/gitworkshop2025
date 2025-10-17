% 17.Oct.2025 For github purposes


clear all


% LOAD 

block1=struct;
block2=struct;
block3=struct;
block4=struct;
block =struct;

matall =NaN;



  for pn=5:16


   for bl =1:4


 fullname = (['block' num2str(bl) '_p' num2str(pn) '_Respmat.mat']);
%fullname = (['block' num2str(bl) '_pbonn1_Respmat.mat']);


 rootname = (['block' num2str(bl) '_p' num2str(pn)]);
%rootname = (['block' num2str(bl) '_pbonn' ]);



block.name{pn} = rootname ;

% block.stim = blockstim ;

% block1=struct ;

if bl == 1
    block1 = block ;
elseif bl ==2
    block2 = block ;
elseif bl ==3
    block3 = block ;
elseif bl ==4
    block4 = block ;
end

% save 

 

if pn == 16 && bl ==1 

 disp 'TER_responses_absolute_block1.mat' 


elseif pn == 16 && bl ==2

 disp 'TER_responses_absolute_block2.mat'


elseif pn == 16 && bl ==3
   
    disp 'TER_responses_absolute_block3.mat'

  elseif pn == 16 && bl ==4
    
      disp 'TER_responses_absolute_block4.mat'

end

end


 end
 
% 
 fullname = (['block' num2str(bl) '_p' num2str(pn) '_Answers.mat']);
% 
