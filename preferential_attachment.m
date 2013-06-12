function edges = preferential_attachment(n,m, tmax)
% INPUTs: n  - # number of nodes to attach at every step
%               m - # edges to attach at every step
%               tmax   - # number of time steps
% OUTPUTs: edge list

vert = 2;
edges=[1 2; 2 1];  % start with an edge

for t = 1:tmax
    vert=vert+n;  % add new vertex(es)
    
    if m>=vert
        for node=1:vert-1
            edges = [edges; vert node];
        end
        continue
    end
    
    deg=[];               % compute nodal degrees for this iteration
    for v=1:vert; deg=[deg; v sum(edges(:,1)==v)]; end
    deg=sortrows(deg);
    
    % add m edges
    rn = rand(1,1);
    if rn < m/(m+1)
        r = randsample(vert,m);
    else
        % Randomly sample the vertexies proportional to their indegree without
        % replacement
        r = randsample(deg(:,1),m,'true',deg(:,2)/max(deg(:,2)));
        while not(length(unique(r))==length(r))
            r = randsample(deg(:,1),m,'true',deg(:,2)/max(deg(:,2)));
        end
    end
    
    for node=1:length(r)
        edges = [edges; vert r(node)];
    end
    
end

outDeg = [];
inDeg = [];
for v=1:vert; outDeg=[outDeg; v sum(edges(:,1)==v)]; end
for v=1:vert; inDeg=[inDeg; v sum(edges(:,2)==v)]; end

vert

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