
%%**********************************************************************************************************
%   Name of Program : NCF-SAR Program
%   Author          : Rahul Kaushal,PRL, Ahmedabad, India. 
%   Email           : rahulkiitgn@gmail.com 
%   Version         : MATLAB 2021a Compactible
%   Description     : This tool enables calculation of NCF-SAR protcol to obtain
%                     sensitivity corrected equivalent dose using direct equation and/or MCM method based on user choice.

%                     Note that this tool is still beta and quite rudimentary.
%   Input           : CSV.
%   Date            : Updated : 14/11/22 
%   Examples        : Use Sample TNLW-3. 
%************************************************************************************************************


Steps-
1) Download 
2) MATLAB function files are advised to store in the same folder or add them to MATALB path 
% Set path for NCF_SAR
(Go to HOME-----Set Path) 
or 
Type addpath('NCF_SAR') in MATLAB command window

3) Prepare format .csv file for data input. Data should be in same format as in example file (TNLW-3).

4) Open MATLAB code named as Run_NCF.m 

or simply type in command window "load_NCFSAR_data".
 
5. Follow instructions appear on command window

6. Once done. It will automaically make a new folder as Results  and NCF corrected excel file will be saved. 

or 
Please see MATLAB_NCF_SAR.pdf (A screenshot).
