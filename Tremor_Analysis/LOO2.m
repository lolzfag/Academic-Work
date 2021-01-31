function Accuracy = LOO2(classA,classB)
%% The codes here handles the total number of patients of 2 classes, slice them out of DataMat and TimeSeries.
load HCTSA_N.mat;
load Diag_ID.mat;
num_D= sum(count(Diagnosis,classA)) + sum(count(Diagnosis,classB));
TruthclassA=cellfun(@(s) contains(s, classA),TimeSeries.Keywords);
PositionclassA = find(TruthclassA == 1);
TruthclassB=cellfun(@(s) contains(s, classB),TimeSeries.Keywords);
PositionclassB = find(TruthclassB == 1);
DiseasePositions = [PositionclassA;PositionclassB];
Sliced_TS = TimeSeries(DiseasePositions,:);
Sliced_TSDM = TS_DataMat(DiseasePositions,:);

%%Further Slicing to decrease number of features to decrease overfitting
if (strcmp(classA,'SCA12') && strcmp(classB,'PD')) || (strcmp(classA,'PD') && strcmp(classB,'SCA12'))
    Sliced_TSDM = Sliced_TSDM(:,ImpSCA12PD);
elseif (strcmp(classA,'ET') && strcmp(classB,'DT')) || (strcmp(classA,'DT') && strcmp(classB,'ET'))
    Sliced_TSDM = Sliced_TSDM(:,ImpETDT);
elseif (strcmp(classA,'ET') && strcmp(classB,'SCA12')) || (strcmp(classA,'SCA12') && strcmp(classB,'ET'))
    Sliced_TSDM = Sliced_TSDM(:,ImpETSCA12);
elseif (strcmp(classA,'ET') && strcmp(classB,'PD')) || (strcmp(classA,'PD') && strcmp(classB,'ET'))
    Sliced_TSDM = Sliced_TSDM(:,ImpETPD);
elseif (strcmp(classA,'PD') && strcmp(classB,'DT')) || (strcmp(classA,'DT') && strcmp(classB,'PD'))
    Sliced_TSDM = Sliced_TSDM(:,ImpDTPD);
elseif (strcmp(classA,'SCA12') && strcmp(classB,'DT')) || (strcmp(classA,'DT') && strcmp(classB,'SCA12'))
    Sliced_TSDM = Sliced_TSDM(:,ImpDTSCA12);
end

Accuracy = 0 ; % Initiates Accuracy, we accumulate this with correctly classified cases, then divide by num_D at the end.

%% Iterations of LOOCV,training models and predict and examine the accuracy of prediction
for i = 1:24
    %The code below cuts one Patient out,which will later be used to
    %examine the performance of our classifier
    STBA = 'P%d_';
    STBA = sprintf(STBA,i); %Format the string in the form of Pn_, where n represents the patient number
    Truth=cellfun(@(s) contains(s, STBA),Sliced_TS.Name); 
    if sum(Truth ~= 0)
        Positions = find(Truth == 1 );% find where is the patient's measurements
        X_predict = Sliced_TSDM(Positions,:);%Take out the Measurements' features of certain patient
        y_predict = Sliced_TS.Group(Positions,:);%Take out the group of the Patient

        X_Train = Sliced_TSDM(setdiff(1:size(Sliced_TSDM,1),Positions),:);
        y_Train = Sliced_TS.Group(setdiff(1:size(Sliced_TS.Group,1),Positions),:);
        %The above codes returned training sets without modifying the original

        Mdl = fitcsvm(X_Train,y_Train); % basic svm model
        [label] = predict(Mdl,X_predict);% Make Predictions using trained model
        Accuracy = Accuracy + (y_predict(1)==mode(label));%Accumulate the correctly predicted results
    else
       continue
    end
end
Accuracy = Accuracy/num_D;
if strcmp(classA,classB)==1
    Accuracy = Accuracy *2; %This is because duplicated class makes num_D 2 times as desired
end

%Computes the total accuracy
end