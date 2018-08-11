% Bioharness

%% A faire
% séparer les sets
% ligne 58 !

%%
corrr = 1

%%
day = {'bioharness_summary_0104','bioharness_summary_3103'}
session = {'1erSession','2ndSession'}
date = {'01_04_14_01','01_04_14_02'}
dateforFabric = {'010414','310314'}

TreeName = './../rawData/'
% 1_data_organized
TreeName0 = [TreeName,'1_data_organized']
InFold0 = dir (TreeName0)

% session
for ii = 3 : length(InFold0) 
    TreeName1 = [TreeName0,'/',InFold0(ii).name]
    InFold1 = dir (TreeName1)
    date4struct = InFold0(ii).name

    % dataTyp
    for jj = 4 % 3 : length(InFold1)% on ne devrait pas parcourir tous les dossiers ! Seul le dossier de notre choix doit être ouvert.
        TreeName2 = [TreeName1,'/',InFold1(jj).name]
        InFold2 = dir (TreeName2)
        dataTyp4struct = InFold1(jj).name


        %%%%%%%%%%% Raw Copy Paste %%%%%

        nFiles = length(InFold2)-2;
        sign2use = [1 2 14 15 31]+6; % HR, BR, HRconfidence, HRV,CoreTemp
        sign2useTimeInc = [4 5 6 ,[sign2use]];
        nDataType = length(sign2use);
        minTimeTab = zeros(nFiles,1);
        maxTimeTab = zeros(nFiles,1);

        %% Fixed variables

        nSubject = nFiles; % 10 fichiers dans bioharness summary 1er session
        nIndex = 10000; % peut-être que cette valeur ne sera pas toujours suffisante...
        subjectNum = cell(1,nSubject);
        fileName_bioharness = cell(1,nSubject);
        data2use = cell(nIndex,nDataType+1,nSubject); % +1 pour intégrer le temps au tableau
        dirNameTab2 ={}

        % sujet
        for kk = 3 : length(InFold2)

            TreeName3 = [TreeName2,'/',InFold2(kk).name]
            InFold3 = dir (TreeName3)

            subj4struct(kk-2) = InFold2(kk).name % la pbm !
            allNames{kk-2}=subj4struct
            
            TreeName4 = [TreeName3,'/',InFold3(3).name]
            InFold4 = dir (TreeName4)

            dossierBH = InFold3(3).name

            % specifique : dossier BH
            InFold4(20).name



            %         for ii = 3 : nFiles+2

            fileTab = [];
            dirNam = [TreeName4,'/',InFold4(20).name]
            dirNameTab{kk-2}= dirNam;

            % lecture des noms de fichiers
%             fileName_bioharness {kk-2}=allNames{kk-2};
%             [A,B,C,D,E,F,G,H] = strread(allNames{kk-2},'%f%f%f%f-%f%f%f%s','delimiter','_');
%             subjectNum{kk-2}=num2str(A);

            % ouverture fichier.

            fid = fopen(dirNam);
            fileTab=textscan (fid,'%f/%f/%f%f:%f:%f%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64','Delimiter',',','Headerlines',1);

            timeAxis = fileTab{4}.*(60*60)+fileTab{5}.*60+fileTab{6};

            data2use(1: length(timeAxis), : , kk-2 )=num2cell([timeAxis, fileTab{7},fileTab{8},fileTab{20},fileTab{21},fileTab{37}]) ;

            minTimeTab (kk-2) = timeAxis(1);
            maxTimeTab (kk-2) = timeAxis(length(timeAxis));

        end

        % minTimeTab;
        % maxTimeTab;
        [commonMinTime,comMinTimInd] = max(minTimeTab);
        [commonMaxTime,comMaxTimInd] = min(maxTimeTab);

        minTimeTabLonger = minTimeTab;
        maxTimeTabLonger = maxTimeTab;

        % minTimeTabLonger(comMinTimInd) = [] cette ligne n'était initialement pas
        % uen remarque.... pourquoi ? Etait-ce un test ?
        % maxTimeTabLonger(comMaxTimInd) = []

        disp(strcat('le fichier qui commence le plus tard est le :  ',allNames{comMinTimInd}))
        ecartDebutCommun = commonMinTime-mean(minTimeTabLonger)

        disp(strcat('le fichier qui se termine le plus tôt est le :  ',allNames{comMaxTimInd}))
        ecartFinCommune = mean(maxTimeTabLonger)-commonMaxTime

        commonPeriod = strcat(num2str((commonMaxTime - commonMinTime)/60),' min')


        for nn = 1 : nFiles
            commonMinTimeIndex(nn) = find (cell2mat(data2use(:, 1,nn))>=commonMinTime,1,'first');
            commonMaxTimeIndex(nn) = find (cell2mat(data2use(:, 1,nn))<=commonMaxTime,1,'last');
            commonTimeIndex (nn) =  commonMaxTimeIndex(nn)-commonMinTimeIndex(nn);
        end

        %% re indexation
        timaxTab = min(commonTimeIndex);
        dataIndexed_bioharness = []

        for nn = 1 : nFiles
            dataIndexed_bioharness (:, : , nn) = cell2mat(data2use(commonMinTimeIndex(nn): commonMinTimeIndex(nn)+ min(commonTimeIndex)-1, : ,nn));
        end

        color = ['r','b','k','c','y','r--','b--','k--','c--','y--'];
        figure,
        for bb=1: nFiles
            plot(dataIndexed_bioharness (:, 3 , bb),color(bb))
            hold on
        end

        hold on
        plot(dataIndexed_bioharness (:, 3 , 2),color(2))


        signal_bioharness = {'TimeAxis','HR','BR','HRConfidence','HRV','Coretemp'};
        subject_bioharness = subjectNum;

        %% fabricFile
        freq = 1
        [fileNam , fileStruct] = fabricFile({dataIndexed_bioharness}, 'bioharness',{signal_bioharness},freq,  date4struct, 'xxx', {subjectNum}, {dirNameTab} ,'220714','smpFreq',1)
        %  [fileNam , structure] = fabricFile({dataIndexed_bioharness}, 'bioharness',{signal_bioharness}, '317082', num2str(sss), {subjectNum}, {dirNameTab} ,'1erTest_befor1707','1stTest')

        %        save (fileNam,'structure' )

        % save(
        %  save 01_04_14_01_bioharness dataIndexed_bioharness
        %  signal_bioharness subject_bioharness fileName_bioharness

        pause

        %%%%%%%%%%%
    end
end
% end

pause


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù
for dd =1 : length(day)
    for sss = 1 : length(session)

        folderRoot =  strcat('./../',day(dd),'/',session(sss))
        allFiles = dir (folderRoot{1})
        allNames = {allFiles.name}
        
        %% Initialisation

        nFiles = length(allNames)-2;
        sign2use = [1 2 14 15 31]+6; % HR, BR, HRconfidence, HRV,CoreTemp
        sign2useTimeInc = [4 5 6 ,[sign2use]];
        nDataType = length(sign2use);
        minTimeTab = zeros(nFiles,1);
        maxTimeTab = zeros(nFiles,1);

        %% Fixed variables

        nSubject = nFiles; % 10 fichiers dans bioharness summary 1er session
        nIndex = 10000; % peut-être que cette valeur ne sera pas toujours suffisante...
        subjectNum = cell(1,nSubject);
        fileName_bioharness = cell(1,nSubject);
        data2use = cell(nIndex,nDataType+1,nSubject); % +1 pour intégrer le temps au tableau
        dirNameTab2 ={}
        
        for ii = 3 : length(allNames)
            fileTab = [];
            dirNam = strcat(folderRoot{1},'\',allNames{ii});
            dirNameTab{ii-2}= dirNam;
          
            
            
            % lecture des noms de fichiers
            fileName_bioharness {ii-2}=allNames{ii};
            [A,B,C,D,E,F,G,H] = strread(allNames{ii},'%f%f%f%f-%f%f%f%s','delimiter','_');
            subjectNum{ii-2}=num2str(A);

            % ouverture fichier.

            fid = fopen(dirNam);
            fileTab=textscan (fid,'%f/%f/%f%f:%f:%f%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64%f64','Delimiter',',','Headerlines',1);

            timeAxis = fileTab{4}.*(60*60)+fileTab{5}.*60+fileTab{6};

            data2use(1: length(timeAxis), : , ii-2 )=num2cell([timeAxis, fileTab{7},fileTab{8},fileTab{20},fileTab{21},fileTab{37}]) ;

            minTimeTab (ii-2) = timeAxis(1);
            maxTimeTab (ii-2) = timeAxis(length(timeAxis));

        end

        % minTimeTab;
        % maxTimeTab;
        [commonMinTime,comMinTimInd] = max(minTimeTab);
        [commonMaxTime,comMaxTimInd] = min(maxTimeTab);

        minTimeTabLonger = minTimeTab;
        maxTimeTabLonger = maxTimeTab;

        % minTimeTabLonger(comMinTimInd) = [] cette ligne n'était initialement pas
        % uen remarque.... pourquoi ? Etait-ce un test ?
        % maxTimeTabLonger(comMaxTimInd) = []

        disp(strcat('le fichier qui commence le plus tard est le :  ',allNames{comMinTimInd}))
        ecartDebutCommun = commonMinTime-mean(minTimeTabLonger)

        disp(strcat('le fichier qui se termine le plus tôt est le :  ',allNames{comMaxTimInd}))
        ecartFinCommune = mean(maxTimeTabLonger)-commonMaxTime

        commonPeriod = strcat(num2str((commonMaxTime - commonMinTime)/60),' min')


        for nn = 1 : nFiles
            commonMinTimeIndex(nn) = find (cell2mat(data2use(:, 1,nn))>=commonMinTime,1,'first');
            commonMaxTimeIndex(nn) = find (cell2mat(data2use(:, 1,nn))<=commonMaxTime,1,'last');
            commonTimeIndex (nn) =  commonMaxTimeIndex(nn)-commonMinTimeIndex(nn);
        end

        %% re indexation
        timaxTab = min(commonTimeIndex);
        dataIndexed_bioharness = []

        for nn = 1 : nFiles
            dataIndexed_bioharness (:, : , nn) = cell2mat(data2use(commonMinTimeIndex(nn): commonMinTimeIndex(nn)+ min(commonTimeIndex)-1, : ,nn));
        end

        color = ['r','b','k','c','y','r--','b--','k--','c--','y--'];
        figure,
        for bb=1: nFiles
            plot(dataIndexed_bioharness (:, 3 , bb),color(bb))
            hold on
        end
 
        hold on
        plot(dataIndexed_bioharness (:, 3 , 2),color(2))


        signal_bioharness = {'TimeAxis','HR','BR','HRConfidence','HRV','Coretemp'};
        subject_bioharness = subjectNum;

        %% fabricFile
        freq = 1
           [fileNam , fileStruct] = fabricFile({dataIndexed_bioharness}, 'bioharness',{signal_bioharness},freq, dateforFabric{dd}, num2str(sss), {subj4struct}, {dirNameTab} ,'220714','smpFreq',1)
%  [fileNam , structure] = fabricFile({dataIndexed_bioharness}, 'bioharness',{signal_bioharness}, '317082', num2str(sss), {subjectNum}, {dirNameTab} ,'1erTest_befor1707','1stTest')

%        save (fileNam,'structure' )

        % save(
        %  save 01_04_14_01_bioharness dataIndexed_bioharness signal_bioharness subject_bioharness fileName_bioharness
    end
end

pause

%% multi select

% disp('HR: 1, BR: 2,	SkinTemp: 3, Posture: 4, Activity: 5, PeakAccel: 6, BatteryVolts: 7, BatteryLevel: 8,	BRAmplitude: 9, BRNoise: 10, BRConfidence: 11, ECGAmplitude: 12,	ECGNoise: 13,	HRConfidence: 14,	HRV: 15,	SystemConfidence: 16,	GSR: 17,	ROGState: 18,	ROGTime: 19,	VerticalMin: 20,	VerticalPeak: 21,	LateralMin: 22,	LateralPeak: 23,	SagittalMin: 24,	SagittalPeak: 25,	DeviceTemp: 26,	StatusInfo: 27,	LinkQuality: 28,	RSSI: 29,	TxPower: 30,	CoreTemp: 31,	AuxADC1: 32,	AuxADC2: 33,	AuxADC3: 34')
disp (' TimeAxis : 1, HR : 2, BR : 3, HRV : 4, Coretemp : 5') % rendre paramétrique

% Qualles entêtes ? 
% % % % nCol = input('nombres de colonnes dans les fichiers ?')
% % % % strColName = ''
% % % % if nCol > 1
% % % % for col = 1:nCol
% % % %     strColName = strcat(','strColName,'%s')
% % % % end
% % % %
% % % % tabTitle = fscanf (fid, strColName)


subject2use = input ('quels sujets souhaitez-vous étudier ?')
nSub = length(subject2use)

sign2use =  input ('quels signaux souhaitez-vous étudier ?')
nSig = length (sign2use)

% importantData
timeStart = dataIndexed{1,1,1}/60;

timeEnd = dataIndexed{length(dataIndexed),1,1}/60 ;

%%

for si = 1 : nSig % nSig figur
    figure,

    for su = 1 : nSub % chaque figure présente tous les sujets
        subplot(nSub,1,su)
        plot(cell2mat(dataIndexed(:,1,su)),cell2mat(dataIndexed(:,si,su)))
        hold on
    end
end


%% correlation work

if corrr == 1

    % xlabel('window size')
    % ylabel('shifting window')
    % zlabel('corr')






    ww=0
    for wdw = 10:10: 210
        ww=ww+1
        for indStart = 1 : timaxTab - wdw

            corrGliss(indStart,ww) = corr(cell2mat(dataIndexed(indStart:indStart+wdw,3,3)),cell2mat(dataIndexed(indStart:indStart+wdw,3,5)));

        end
    end
    % [xx,yy] = meshgrid([10:10: 210, 1 : timaxTab - wdw ]);
    figure, surf(10:10: 210, 1 : timaxTab - 10 ,corrGliss.^2)
    xlabel('window size')
    ylabel('shifting window')
    zlabel('corr^2')

    size(10:50: 210)
    size( 1 : timaxTab-10)
    size( corrGliss)

end