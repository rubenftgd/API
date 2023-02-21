[Pre, Post, M0]= rdp('Petri_mahle.xml')
[A, B]= reach_graph( Pre, Post, M0 )
disp_gr( A, B )