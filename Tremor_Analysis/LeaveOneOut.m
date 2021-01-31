% Group 1= ET, 2= DT, 3= SCA12, 4= PD
function LeaveOneOut
load HCTSA_N.mat;

%%Further Slicing to decrease number of features to decrease overfitting
TS_DataMat = TS_DataMat(:,ImpALL);

Accuracy = 0 ;
for i = 1:24
    %The code below cuts one Patient out,which will later be used to
    %examine the performance of our classifier
    STBA = 'P%d_';
    STBA = sprintf(STBA,i); %Format the string in the form of Pn_, where n represents the patient number
    Truth=cellfun(@(s) contains(s, STBA),TimeSeries.Name); 
    Positions = find(Truth == 1 );% find where is the patient's measurements
    X_predict = TS_DataMat(Positions,:);%Take out the Measurements' features of certain patient
    y_predict = TimeSeries.Group(Positions,:);%Take out the group of the Patient
    
    X_Train = TS_DataMat(setdiff(1:size(TS_DataMat,1),Positions),:);
    y_Train = TimeSeries.Group(setdiff(1:size(TimeSeries.Group,1),Positions),:);
    %The above codes returned training sets without modifying the original
    
    Mdl = fitcecoc(X_Train,y_Train); % chose to use multi-class classifier as it performs substaintially better than rsvm
    [label] = predict(Mdl,X_predict);% Make Predictions using trained model
    Accuracy = Accuracy + (y_predict(1)==mode(label));%Accumulate the correctly predicted results
    
end
Accuracy = Accuracy/24
% compute the total costs