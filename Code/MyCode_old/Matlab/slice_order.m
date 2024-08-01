% this function is used to find ou the slice order of fMRI data. 
% you need to set up filefolder and dicom file name.
% the result is in the matrix TT_SL, 1 colum.
% copyright: Xueru Fan @BNU Nov 8 2021

clear;clc;

filefolder = strcat(['/Users/fanxueru/Documents/OneDrive/xueru/PhD/PhDproject/example_data/Anyang_Xueru/Rest/dcm/']);
cd (filefolder);

ToCheck = dicominfo('3.0.dcm');

SliceNumber = ToCheck.ImagesInAcquisition/ToCheck.NumberOfTemporalPositions;
TR = ToCheck.RepetitionTime;

TT_SL = zeros(SliceNumber,3);

for i = 1:SliceNumber;
    filename = strcat([num2str(i),'.0.dcm']);
    img = dicominfo(filename);
    TT_SL(i,1) = i;
    TT_SL(i,2) = img.TriggerTime;
    TT_SL(i,3) = img.SliceLocation;
end

TT_SL = sortrows(TT_SL,2);
clearvars -except TT_SL SliceNumber TR
