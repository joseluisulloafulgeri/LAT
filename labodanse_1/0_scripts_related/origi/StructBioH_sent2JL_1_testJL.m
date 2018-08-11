% make structure from Bioharness sensor files.

close all 
clear all


%% open initial root

TreeName0 = './../1_data_organized' 
InFold0 = dir (TreeName0); % open the first level directory

%% open session folders 
for ii = 3 : length(InFold0)
    
    TreeName1 = [TreeName0,'/',InFold0(ii).name] % concatenate the second level directory, with the files / folders found in the first level dir.
    InFold1 = dir (TreeName1);
    
    [yr2,mt2,da2,sss]=strread(InFold0(ii).name,'%f%f%f%s','delimiter','_'); % read folder infos to get the date
    date4struct = [num2str(yr2),'-',num2str(mt2),'-',num2str(da2),'-',sss{1}]; % create the formated string of the date, for the future structure name

    %% open dataTyp folder 
    %
    % switch case here....?????
    %%%%%%
    for jj = 4 
    %%%%%%  
    %    
    %    
        TreeName2 = [TreeName1,'/',InFold1(jj).name]
        InFold2 = dir (TreeName2);
        
        [num,dataTyp,extraInfo] = strread(InFold1(jj).name,'%f%s%s','delimiter','_'); % extract data type name to complete both futur structure name and dataType field
        dataTyp4struct = dataTyp;

        nSubject = length(InFold2)-2; % number of subject folders in the dataType folder
        
        % has to be programmed in a better way
        %%%%
        sign2use = [1 2 14 15 31]+6; % index in BioH files of HR, BR, HRconfidence, HRV,CoreTemp [+6 to cope with the time columns]
        sign2useTimeInc = [1,[sign2use]-5];
        %%%% 
        %
        
        minTimeTab = [];
        maxTimeTab = [];

        data2use = cell(1,nSubject); % initialisation of the cell which will contain the all batch of raw data

        %% loop to open and include all subjects raw data matrix in the cell
        for kk = 3 : length(InFold2)

            subj4struct{kk-2} = InFold2(kk).name; % list each subject number in a cell for future structure field listSubj
            
            TreeName3 = [TreeName2,'/',InFold2(kk).name]
            InFold3 = dir (TreeName3);

            TreeName4 = [TreeName3,'/',InFold3(3).name] % [3] car le seul dossier pr�sent est le bon. Ce n'est pas forc�ment le cas !!!
            InFold4 = dir (TreeName4);

            %% we are know in the subfolder given the bioharness sensor,
            %% let's collect informations in the name of the included
            %% files : 
           [yr,mt,da,hr,mn,sc,daTyp] = strread(InFold4(9).name,'%f%f%f-%f%f%f%s','delimiter','_');
       	
            dirNam = [TreeName4,'/',InFold4(9).name]
            dirNameTab4struct{kk-2}= dirNam; % list each file directory in a cell for future structure field source
            
            fileTab = [];
            
            % ouverture fichier.
            fid = fopen(dirNam);
            
            HDRL= fgets(fid);
            hl = textscan(HDRL,'%s','delimiter',','); % lecture des headliners
            
            %
            % as line 37
            %%%%%
            dataList4struct = hl{1}(sign2useTimeInc)
            %%%%%
            %
            %
            
            initialCol = '%f/%f/%f%f:%f:%f'; % initialise the variable discribed below
            for nCol = 1 : length(hl{1})
                initialCol = [initialCol,'%f64']; % create a variable which contain as many %f fields as headliner fields
            end

            fileTab= textscan (fid,initialCol,'Delimiter',',','Headerlines',1); % extraction de toutes les valeurs du fichier source

            
            timeAxis = fileTab{4}.*(60*60)+fileTab{5}.*60+fileTab{6}; % formatage du timestamp en secondes
            dataFileTab = cell2mat(fileTab(sign2use)); % s�lection des colonnes de valeurs � structurer
            data2use{1, kk-2}=num2cell([timeAxis, dataFileTab]) ; %[1 2 14 15 31]+6;

            minTimeTab (kk-2) = timeAxis(1); % get the starting time of the current file
            maxTimeTab (kk-2) = timeAxis(length(timeAxis)); % get the end time of the file

        end

        
        [commonMinTime,comMinTimInd] = max(minTimeTab); 
        [commonMaxTime,comMaxTimInd] = min(maxTimeTab);

        %% include the limiting file in the field "remarq" of the structure
        
        remarq4struct{1} = ['TIMESTAMP : CommonMinTime fixed by ', dirNameTab4struct{comMinTimInd}]
        remarq4struct{2} = ['TIMESTAMP : CommonMaxTime fixed by ', dirNameTab4struct{comMaxTimInd}]
        remarq4struct{3} = strcat('TIMESTAMP : Length of the session : ',num2str((commonMaxTime - commonMinTime)/60),' min')

        for nn = 1 : nSubject
            commonMinTimeIndex(nn) = find (cell2mat(data2use{nn}(:,1))>=commonMinTime,1,'first');
            commonMaxTimeIndex(nn) = find (cell2mat(data2use{nn}(:,1))<=commonMaxTime,1,'last');
            commonTimeIndex (nn) =  commonMaxTimeIndex(nn)-commonMinTimeIndex(nn); % verifier le timestamp(commonTimeIndex) de chaque sujet, et les comparer => ils doivent �tre quasi identiques.
        end

        %% re indexation
        NIndMax = min(commonTimeIndex); % maximum length of the synchronised file
        
        dataIndexed_bioharness = []
        for nn = 1 : nSubject
            dataIndexed_bioharness (:, : , nn) = cell2mat(data2use{nn}(commonMinTimeIndex(nn): commonMinTimeIndex(nn)+ NIndMax-1,:)); % build a 3D matrix with the synchronised data
        end

    %% d�terminer l'heure de commencement � partir du TimeAxis du fichier
    val = dataIndexed_bioharness(1,1,1)
    HH = floor(val/60^2);
    MN = floor((val - HH*60^2)/60);
    SC = ((val - HH*60^2 - MN*60));
    
    time4struct = [num2str(HH),'-',num2str(MN),'-',num2str(floor(SC))] % get the beginning time of the structure so as to including it in the structure name.
        
        %% fabricFile
        samplingFreq = 1
        
        % input + preview infos about the futur structure before to create
        % and save the structure to come...
        %%
        sav = 1
        %%
        %
        [fileNam , fileStruct] = fabricFile3({dataIndexed_bioharness}, 'bioharness',dataList4struct, samplingFreq,  date4struct, time4struct, {subj4struct}, {dirNameTab4struct} ,{remarq4struct},'smpFreq',sav)
    end
end


pause

