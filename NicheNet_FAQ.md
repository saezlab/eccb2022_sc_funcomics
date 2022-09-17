# FAQ

## I dont have two conditions in my data, can I still use NicheNet?

Yes, but it depends on your biological question. 

For example, if you want to predict ligands regulating one certain biological process in a receiver cell type, you can follow the steps described in this tutorial: [NicheNet’s ligand activity analysis on a gene set of interest](https://github.com/saeyslab/nichenetr/blob/master/vignettes/ligand_activity_geneset.md). There we applied NicheNet to find fibroblast ligands that might induce a partial epithelial-mesenchymal-transition program in malignant cells. Even though the genes of this partial epithelial-mesenchymal-transition program were not determined via classical DE analysis, they still represent a set of genes that might be regulated by the extracellular environment. And that is the only requirement to run a NicheNet analysis.

Another example is if you want to predict ligands regulating a cellular differentiation process. You don't have two conditions but you can determine DE genes between the differentiated cell and the progenitor cell to predict upstream ligands that might have caused these gene expression changes.

You can read more about this here [What if I only have steady-state data and want to use NicheNet?]( https://github.com/saeyslab/nichenetr/blob/master/vignettes/faq.md#when-going-to-the-vignettes-i-see-you-require-differential-expression-between-two-conditions-what-if-i-only-have-steady-state-data-and-want-to-use-nichenet-cant-nichenet-be-used-to-find-ligand-receptor-pairs-in-steady-state)

## What can NicheNet do and what not?

NicheNet can rank sender cell ligands based on their gene regulatory effect on a receiver cell (= based on enrichment of predicted target genes). It then gives the corresponding receptors and predicted target genes of the top-ranked ligands.

What NicheNet cannot do is: 

1) determine which ligands are important and which not in a black-white manner (based on eg statistical significance)

2) determine all important ligand-receptor pairs, count them per sender-receiver combination, and define in this way which sender-receiver interactions are the most important in your data. If you really want to do that, you can start from the output of other tools like [LIANA](https://github.com/saezlab/liana) or [CellPhoneDB](https://www.cellphonedb.org/).

3) prioritize ligand-receptor pairs based on cell-type specificity or their differential expression strength. If you want to prioritize ligand-receptor pairs based on cell-type specificity, you can use other tools like [LIANA](https://github.com/saezlab/liana) or [CellPhoneDB](https://www.cellphonedb.org/). If you want to include differential expression in the prioritization, you can use [Differential NicheNet](https://github.com/saeyslab/nichenetr/blob/master/vignettes/differential_nichenet_pEMT.md).

4) be directly used on steady-state data without specific biological question (see previous question). In that case you can use other tools like [LIANA](https://github.com/saezlab/liana) or [CellPhoneDB](https://www.cellphonedb.org/).

5) say which cell types interact with each other and which not. At best, it can only suggest this. See [Can NicheNet say which cell populations interact with each other and which don’t?]( https://github.com/saeyslab/nichenetr/blob/master/vignettes/faq.md#can-nichenet-say-which-cell-populations-interact-with-each-other-and-which-dont)


## I have multiple levels of hierarchy in my cell type annotation. Which one should I use?

The answer to this question strongly depends on your specific data and biological question. The most important thing is that you can define the geneset of interest in such a way that it addresses your biological question.

As example: if you are interested in predicting ligands that might drive CD4T cell skewing towards certain T helper populations (Th1, Th2, Th17, ...), you can best use all CD4T cells as receiver cells. DE genes in CD4T cells between two conditions will give insight about which differentiation direction occurs, and this will give rise to a ranking of ligands inducing this differentiation. In case your condition of interest induces a Th17 phenotype in CD4T cells, Th17-related genes in CD4T cells will be upregulated, and Th17-promoting ligands will be predicted by NicheNet. 

If on the contrary you are interested in how eg Th17 CD4T cells are differently interacting in two conditions, you should use that level of annotation and use Th17 CD4T cells as receiver cells. 

Note that this question is also strongly related to the discussion of differential abundance versus differential expression. 

## The ligand-target heatmap shows which ligand-target links are supported by more prior knowledge than others. Can I also see which prior knowledge / database are behind which links?

Yes this is possible. If you want to do check the signaling pathways underlying some of the ligand-target links, you can follow the steps described in this tutorial: [Inferring ligand-to-target signaling paths](https://github.com/saeyslab/nichenetr/blob/master/vignettes/ligand_target_signaling_path.md).

## I dont have an idea about the most interesting receiver cell type in my data. Can I use NicheNet?

Yes, you can use NicheNet, but you will need to run separate analyses for each cell type.

## Although NicheNet already prioritizes ligand-receptor pairs strongly, I still find there are too many possible pairs to experimentally validate. What types of information would you recommend to consider for even further prioritization?

First, you can consider the NicheNet ligand activity (as you already did). But instead of having a strong preference for the 1st ranked ligand versus the 5th ligand, I suggest also taking into account the expression level of both ligand and receptor. For this you can look at the expression value, the fraction of cells expressing the ligand/receptor and whether the ligand/receptor is cell-type specific or not. In the ideal case, you would have case-vs-control data and you could also look at ligands/receptor pairs for which the ligand and/or receptor is upregulated in the case vs control condition. 

## Where can I read more about the details behind a NicheNet analysis?

You can check the NicheNet paper and it's supplementary material at: https://www.nature.com/articles/s41592-019-0667-5

## What are some limitations of NicheNet? 

1) Applying NicheNet on scRNAseq data, just like the other cell-cell communication tools, gives predictions based on RNA data. However, ligand-receptor interactions and signal transduction occurs at the protein level! However, if a strong enrichment of target genes of a ligand is found in a receiver, it might indicate that this ligand, found to be expressed at RNA level, might have been present at protein level as well. Moreover, if you would have proteomics data of your cells, you can define your expressed ligands and receptors based on your proteomics data instead of the scRNAseq data.

2) NicheNet prioritizes based on ligand activities, which are based on prior knowledge. For some ligands, we don't have accurate prior knowledge, and for some cell types, the effect of a ligand might be very different than for other celltypes. This can make that prior knowledge about the signaling of one ligand might be accurate for one cell type, but not for another. NicheNet cannot take into account this context-specificity. Nor does it take into account the complexity of pathway crosstalks and how one ligand might affect the signaling of another ligand. But we are convinced that the 'footprint'-based approach of NicheNet to predict active ligand works for many ligands and many datasets, as demonstrated in the validation study of the NicheNet paper. While NicheNet might not very accurately predict the effect of a ligand on the entire transcriptome, the presence of a few known specific target genes of a certain ligand (the ligand's "footprint") is sufficient in many cases to predict that that ligand is more important than another ligand of which no footprint is found.

3) NicheNet does not directly take into account spatial information. If you would have spatial information, you can better select relevant sender and receiver cell types as input for NicheNet.

## My question is not in this list? What should I do now?

First, you can check the [NicheNet FAQ page](https://github.com/saeyslab/nichenetr/blob/master/vignettes/faq.md).
If your question is not there, you can check the open and closed [Github Issues](https://github.com/saeyslab/nichenetr/issues) to see whether your question might be addressed in one of these. If not, don’t hesitate to open a new issue. If you would prefer to keep the discussion private, you can also send an email (yvan.saeys@ugent.be), but I prefer that you open an issue so other users can learn from it as well!
  