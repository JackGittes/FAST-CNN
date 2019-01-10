function offset = getSectionEndAddr(section)
    paramsEnd = section(end);
    if ~isempty(paramsEnd.BiasEnd)
        offset = paramsEnd.BiasEnd;
    elseif ~isempty(paramsEnd.KernelEnd)
        offset = paramsEnd.KernelEnd;
    else
        error("Can't find the end address of the final section.");
    end
end