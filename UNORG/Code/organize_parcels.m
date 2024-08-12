function Y = organize_parcels(X, nparcels, option)

% 本脚本用来整合HCP数据Yeo100-1000个分区的7个网络
% Xueru Fan #1-Dec-2021 @BNU

% X (列向量)
% nparcels (100:100:1000)
% option (0 = 全脑，1 = 左半球，2 = 右半球）

% 信息来自https://github.com/ThomasYeoLab/CBIG/tree/master/ ...
% stable_projects/brain_parcellation/Schaefer2018_LocalGlo ...
% bal/Parcellations/MNI/Centroid_coordinates

% 注意：1000个分区的999和1000分区属于Cont网络

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
id = 
[1 9 10 15 16 23 24 30 31 33 34 37 NaN NaN 38 50
51 58 59 66 67 73 74 78 79 80 81 89 NaN NaN 90 100
1 14 15 30 31 43 44 54 55 60 61 73 NaN NaN 74 100
101 115 116 134 135 147 148 158 159 164 165 181 NaN NaN 182 200
1 24 25 53 54 69 70 85 86 95 96 112 NaN NaN 113 150
151 173 174 201 202 219 220 237 238 247 248 270 NaN NaN 271 300
1 31 32 68 69 91 92 113 114 126 127 148 NaN NaN 149 200
201 230 231 270 271 293 294 318 319 331 332 361 NaN NaN 362 400
1 39 40 86 87 111 112 138 139 154 155 185 NaN NaN 186 250
251 285 286 334 335 365 366 397 398 414 415 452 NaN NaN 453 500
1 45 46 101 102 136 137 170 171 192 193 228 NaN NaN 229 300
301 344 345 400 401 437 438 476 477 496 497 542 NaN NaN 543 600
1 58 59 122 123 165 166 201 202 224 225 263 NaN NaN 264 350
351 412 413 476 477 520 521 559 560 585 586 637 NaN NaN 638 700
1 67 68 142 143 189 190 229 230 258 259 303 NaN NaN 304 400
401 467 468 543 544 595 596 642 643 667 668 726 NaN NaN 727 800
1 75 76 162 163 214 215 263 264 292 293 340 NaN NaN 341 450
451 522 523 608 609 660 661 716 717 747 746 816 NaN NaN 817 900
1 81 82 172 173 233 234 288 289 317 318 374 NaN NaN 375 500
501 581 582 684 685 745 746 811 812 842 843 912 999 1000 913 998];

L.Vis = X(id(x,1):id(x,2),:);
L.SomMot = X(id(x,3):id(x,4),:);
L.DorsAttn = X(id(x,5):id(x,6),:);
L.SalVentAttn = X(id(x,7):id(x,8),:);
L.Limbic = X(id(x,9):id(x,10),:);
L.Cont = X(id(x,11):id(x,12),:);
L.Default = X(id(x,15):id(x,16),:);

M.Vis = X([id(x,1):id(x,2) id(y,1):id(y,2)],:);
M.SomMot = X([id(x,3):id(x,4) id(y,3):id(y,4)],:);
M.DorsAttn = X([id(x,5):id(x,6) id(y,5):id(y,6)],:);
M.SalVentAttn = X([id(x,7):id(x,8) id(y,7):id(y,8)],:);
M.Limbic = X([id(x,9):id(x,10) id(y,9):id(y,10)],:);
M.Cont = X([id(x,11):id(x,12) id(y,11):id(y,12)],:);
M.Default = X([id(x,15):id(x,16) id(y,15):id(y,16)],:);

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
if nparcels = 100
    Y.name = {
        }
    if option = 1
        x = 1; 
        Y = L;
    elseif option = 2
        x = 2;
        Y = L;
    elseif
        x = 1; y = 2;
        Y = M;
    else
       fprintf ('Wrong input value:option. \n')      
    end

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %    
elseif nparcels = 200
    Y.name = {
        }
    if option = 1
        x = 3; 
        Y = L;
    elseif option = 2
        x = 4;
        Y = L;
    elseif
        x = 3; y = 4;
        Y = M;
    else
       fprintf ('Wrong input value:option. \n')      
    end
    
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %  
elseif nparcels = 300
    Y.name = {
        }
    if option = 1
        x = 5; 
        Y = L;
    elseif option = 2
        x = 6;
        Y = L;
    elseif
        x = 5; y = 6;
        Y = M;
    else
       fprintf ('Wrong input value:option. \n')      
    end
    
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %  
elseif nparcels = 400
    Y.name = {
        }
    if option = 1
        x = 7; 
        Y = L;
    elseif option = 2
        x = 8;
        Y = L;
    elseif
        x = 7; y = 8;
        Y = M;
    else
       fprintf ('Wrong input value:option. \n')      
    end   
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
elseif nparcels = 500
    Y.name = {
        }
    if option = 1
        x = 9; 
        Y = L;
    elseif option = 2
        x = 10;
        Y = L;
    elseif
        x = 9; y = 10;
        Y = M;
    else
       fprintf ('Wrong input value:option. \n')      
    end   

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
elseif nparcels = 600
    Y.name = {
        }
    if option = 1
        x = 11; 
        Y = L;
    elseif option = 2
        x = 12;
        Y = L;
    elseif
        x = 11; y = 12;
        Y = M;
    else
       fprintf ('Wrong input value:option. \n')      
    end    

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
elseif nparcels = 700
    Y.name = {
        }
    if option = 1
        x = 13; 
        Y = L;
    elseif option = 2
        x = 14;
        Y = L;
    elseif
        x = 13; y = 14;
        Y = M;
    else
       fprintf ('Wrong input value:option. \n')      
    end      

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
elseif nparcels = 800
    Y.name = {
        }
    if option = 1
        x = 15; 
        Y = L;
    elseif option = 2
        x = 16;
        Y = L;
    elseif
        x = 15; y = 16;
        Y = M;
    else
       fprintf ('Wrong input value:option. \n')      
    end
    
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
elseif nparcels = 900
    Y.name = {
        }
    if option = 1
        x = 17; 
        Y = L;
    elseif option = 2
        x = 18;
        Y = L;
    elseif
        x = 17; y = 18;
        Y = M;
    else
       fprintf ('Wrong input value:option. \n')      
    end      

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
elseif nparcels = 1000
    Y.name = {
        }
    if option = 1
        x = 19; 
        Y = L;
    elseif option = 2
        x = 20;
        Y = L;
        Y.Cont = X(id(x,11):id(x,14) ,:);
    elseif
        x = 19; y = 20;
        Y = M;
        Y.Cont = X([id(x,11):id(x,14) id(y,11):id(y,14)],:);
    else
       fprintf ('Wrong input value:option. \n')      
    end
 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %    
else
    fprintf ('Wrong input value:nparcels. \n')
end
    
clearvars -except Y nparcels
end
