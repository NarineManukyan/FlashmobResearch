function edges = preferential_attachmentEfficient(n,m, tmax)
% INPUTs: n  - # number of nodes to attach at every step
%               m - # edges to attach at every step
%               tmax   - # number of time steps
% OUTPUTs: edge list

vert = 2;
edges=[1 2; 2 1];  % start with an edge
targets = [1 2]; % list of all targets

for t = 1:tmax
    vert=vert+n;  % add new vertex(es)
    
    if m>=numel(unique(targets))
        for node=1:vert-1
            edges = [edges; vert node];
            targets = [targets node];
        end
        continue
    end
    
    % add m edges
    rn = rand(1,1);
    if rn < m/(m+1)
        % Randomly sample the vertexies proportional to their indegree without
        % replacement
        ct = 1;
        r = [];
        targetse = targets;
        while ct < m
            re = randsample(targetse,1);
            if ~sum(r == re)
                r(ct) = re;
                ct = ct+1;
                targetse(targetse == re)=[];
            end
        end
        
    else
        r = randsample(vert,m);
    end
    
    for node=1:length(r)
        edges = [edges; vert r(node)];
        targets = [targets: r(node)];
    end
    
end

outDeg = [];
inDeg = [];
for v=1:vert; outDeg=[outDeg; v sum(edges(:,1)==v)]; end
for v=1:vert; inDeg=[inDeg; v sum(edges(:,2)==v)]; end


figure
for d = 1:max(inDeg(:,2))
    inDegFraction(d) = sum(inDeg(:,2)==d);
end
plot(inDegFraction./vert);
set(gca,'FontSize',15, 'FontWeight','bold');
xlabel('In-degree q');
ylabel('Fraction of vertices with in-degree q');

figure
loglog(inDegFraction./vert);
set(gca,'FontSize',15, 'FontWeight','bold');
xlabel('In-degree q');
ylabel('Fraction of vertices with in-degree q');
title('LogLog plot');