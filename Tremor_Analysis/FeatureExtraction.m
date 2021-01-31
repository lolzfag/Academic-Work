load HCTSA.mat

for i=1:size(TimeSeries,1)
    datanow=TimeSeries(i,:).Data{1};   % Take out the tremor time-series data
    
    [FVnow,calcTnow,calcQnow] = TS_CalculateFeatureVector(datanow,true); 
    % Load the retured matrices into the structure explained before
    TS_DataMat(i,:)=FVnow;      % Feature vector
    TS_CalcTime(i,:)=calcTnow;    % Calculation time
    TS_Quality(i,:)=calcQnow;      % Feature quality
    
end

% Load all of them back into HCTSA.mat again

save('HCTSA.mat','TimeSeries','MasterOperations','Operations','TS_DataMat','TS_Quality','TS_CalcTime','gitInfo','fromDatabase','groupNames');
