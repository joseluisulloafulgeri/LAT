%% FabricName, FabricList

function  [fileNam , fileStruct] = fabricFile3(data, dataType,listData, freq, date, session, listSubSensors, listFile,remarq,remarqTitre,sav)

fileName = strcat (dataType,'_', date,'_', num2str(session),'_', remarqTitre)  %, num2str(length(listSubSensors{:})),'nSubj');
fileNam = [fileName]

file = strcat (dataType,'_', date,'_', num2str(session));

fileStruct = struct('name',fileName,'data',data, 'signal',dataType, 'listData',{listData},'samplingFreq',freq,'subj',listSubSensors,'source',listFile,'remarqs',remarq);
    
if sav == 1
    save (fileNam,'fileStruct')% pour le openBioH => tjrs pbm avec fileNam{1}
    disp(strcat('file saved under : ',fileNam))
else
    disp('file not saved')
end


% eval([genvarname( file) '= structur']);
% pause
% file
