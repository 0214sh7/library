# bash

#cat ./wild.txt > ../_posts/0000-01-01-wild.md
echo '---' > ../_posts/0000-01-01-wild.md
echo 'title: "すくライブラリ"' >> ../_posts/0000-01-01-wild.md
echo 'permalink: /posts/wild' >> ../_posts/0000-01-01-wild.md
echo 'writer: 0214sh7' >> ../_posts/0000-01-01-wild.md
echo 'layout: library' >> ../_posts/0000-01-01-wild.md
echo '---' >> ../_posts/0000-01-01-wild.md
echo '' >> ../_posts/0000-01-01-wild.md

echo '<style>' >> ../_posts/0000-01-01-wild.md
echo '    pre, code {' >> ../_posts/0000-01-01-wild.md
echo '        white-space: pre-wrap;' >> ../_posts/0000-01-01-wild.md
echo '    }' >> ../_posts/0000-01-01-wild.md
echo '</style>' >> ../_posts/0000-01-01-wild.md
echo '' >> ../_posts/0000-01-01-wild.md




tail -q -n +7 ../index.md >> tmp.md
cat tmp.md >> ../_posts/0000-01-01-wild.md
echo '' >> ../_posts/0000-01-01-wild.md
echo '---' >> ../_posts/0000-01-01-wild.md
echo '<div style="page-break-after: always;"></div>' >> ../_posts/0000-01-01-wild.md
echo '' >> ../_posts/0000-01-01-wild.md

items=(
    ../_posts/2023-06-29-basic-math-assortment.md
    ../_posts/2023-06-29-binomial-coefficient.md
    ../_posts/2023-06-29-sieve.md
    ../_posts/2023-06-29-bezout-coef.md
    ../_posts/2023-06-29-convex-hull.md
    ../_posts/2023-06-29-euler-totient.md
    ../_posts/2023-06-29-fft.md
    ../_posts/2023-06-29-ntt.md
    ../_posts/2023-06-29-composite-binomial-coefficient.md

    ../_posts/2023-06-29-vector2d-rotate.md
    ../_posts/2023-06-29-run-length-encode.md
    ../_posts/2023-06-29-arg-sort.md
    ../_posts/2023-06-29-iterated-function.md
    ../_posts/2023-06-29-slide-minimum.md
    ../_posts/2023-06-29-compress.md
    ../_posts/2023-06-29-lis.md
    ../_posts/2023-06-29-mos-algorithm.md
    ../_posts/2023-06-29-rollinghash.md

    ../_posts/2023-06-29-dijkstra.md
    ../_posts/2023-06-29-bellmanford.md
    ../_posts/2023-06-29-kruskal.md
    ../_posts/2023-06-29-bipartite-graph.md
    ../_posts/2023-06-29-double-sweep.md
    ../_posts/2023-06-29-lowest-common-ancestor.md
    ../_posts/2023-06-29-dinic.md

    ../_posts/2023-06-29-segment-tree.md
    ../_posts/2023-06-29-fenwick-tree.md
    ../_posts/2023-06-29-unionfind.md
    ../_posts/2023-06-29-pot-unionfind.md
)

#for i in ../_posts/2*.md; do
for i in "${items[@]}"; do
    
    sed -n 2p $i > tmp.md
    j=$(<tmp.md)
    j1=${j:8}
    j2=${j1:0:-1}

    echo '#' 🔴 $j2 🔴  > tmp.md

    tail -q -n +7 $i >> tmp.md
    cat tmp.md >> ../_posts/0000-01-01-wild.md

    echo '' >> ../_posts/0000-01-01-wild.md
    echo '' >> ../_posts/0000-01-01-wild.md
    echo '<div style="page-break-after: always;"></div>' >> ../_posts/0000-01-01-wild.md
    echo '' >> ../_posts/0000-01-01-wild.md
    
done

rm tmp.md