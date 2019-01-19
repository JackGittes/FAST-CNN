function res = BiasConverter(varargin)
    bias_vec = varargin{1};
    bias_array = bias_vec(:)';
    if length(varargin)>1
        res = [findBestFactor(bias_array),FAST.VP.AI.BiasConverter(varargin{2:end})];
    else
        res = findBestFactor(bias_array);
    end
end

function res = findBestFactor(bias)
    bias_mat = repmat(bias,127,1);
    fac_UINT8 = repmat((1:127)',1,length(bias));
    bias_factorized = round(bias_mat./fac_UINT8);
    
    % Saturated Cast Factorized Bias into UINT8
    bias_factorized(bias_factorized > 127)=127;
    bias_factorized(bias_factorized < -128)=-128;
    
    % Re-construct bias with bias_factorized and fac_UINT8
    bias_reconsrt = bias_factorized.* fac_UINT8;
    
    % Calculate Diff between original bias and re-constructed bias.
    delta_ = sum(abs(bias_reconsrt-bias_mat).^2,2);
    [~,res] = min(delta_);
end