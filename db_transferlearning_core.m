function st_network = db_transferlearning_core(x_train,y_train,net)

layersTransfer = freezeWeights(net.Layers(1:end-3));
numClasses =numel(unique(y_train));
layers = [
    layersTransfer
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

inputSize = net.Layers(1).InputSize;

augimdsTrain = augmentedImageDatastore(inputSize,x_train,categorical(y_train));

options = trainingOptions('sgdm', ...
    'MaxEpochs',30, ...
    'MiniBatchSize',40,...
    'Shuffle','every-epoch', ...
    'Verbose',true);

st_network = trainNetwork(augimdsTrain,layers,options);

end

function layers = freezeWeights(layers)

for ii = 1:size(layers,1)
    props = properties(layers(ii));
    for p = 1:numel(props)
        propName = props{p};
        if ~isempty(regexp(propName, 'LearnRateFactor$', 'once'))
            layers(ii).(propName) = 0;
        end
    end
end

end



