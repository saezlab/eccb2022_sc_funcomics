nichenet_covid19_wrapper = function(receiver, DE_table, sobj,  liana_res, ligand_target_matrix){

  potential_ligands <- liana_res %>%
    filter(target == receiver) %>%
    pull(ligand.complex) %>% unique() %>%
    intersect(colnames(ligand_target_matrix)) # only keep common ligands
  
  geneset_oi <- DE_table %>% filter(contrast == receiver) %>%
    filter(pvals < 0.05 & abs(logFCs) > 0.50) %>%
    pull(name) %>% unique()
  
  background_expressed_genes <- DE_table %>%
    filter(contrast == receiver) %>%
    pull(name) %>%
    unique()

  geneset_oi <- geneset_oi %>%
    .[. %in% rownames(ligand_target_matrix)]
  background_expressed_genes <- background_expressed_genes %>%
    .[. %in% rownames(ligand_target_matrix)]

  ligand_activities <- predict_ligand_activities(geneset = geneset_oi, background_expressed_genes = background_expressed_genes, ligand_target_matrix = ligand_target_matrix, potential_ligands = potential_ligands)
  
  ligand_activities <- ligand_activities %>% arrange(-aupr) %>% mutate(rank = rank(desc(aupr)))

  best_upstream_ligands <- ligand_activities %>% top_n(30, aupr) %>% arrange(-aupr) %>% pull(test_ligand) %>% unique()

  p_ligand_expression = Seurat::DotPlot(sobj, features = best_upstream_ligands, cols = "RdYlBu") + Seurat::RotatedAxis()
  
  active_ligand_target_links_df <- best_upstream_ligands %>% lapply(get_weighted_ligand_target_links,geneset = geneset_oi, ligand_target_matrix = ligand_target_matrix, n = 500) %>% bind_rows() %>% drop_na()
  active_ligand_target_links <- prepare_ligand_target_visualization(ligand_target_df = active_ligand_target_links_df, ligand_target_matrix = ligand_target_matrix, cutoff = 0.33)
  order_ligands <- intersect(best_upstream_ligands, colnames(active_ligand_target_links)) %>% rev() %>% make.names()
  order_targets <- active_ligand_target_links_df$target %>% unique() %>% intersect(rownames(active_ligand_target_links)) %>% make.names()
  rownames(active_ligand_target_links) <- rownames(active_ligand_target_links) %>% make.names() # make.names() for heatmap visualization of genes like H2-T23
  colnames(active_ligand_target_links) <- colnames(active_ligand_target_links) %>% make.names() # make.names() for heatmap visualization of genes like H2-T23
  vis_ligand_target <- active_ligand_target_links[order_targets,order_ligands] %>% t()
  
  p_ligand_target_network <- vis_ligand_target %>% make_heatmap_ggplot("Prioritized ligands","Predicted target genes", color = "purple",legend_position = "top", x_axis_position = "top",legend_title = "Regulatory potential")  + theme(axis.text.x = element_text(face = "italic")) + scale_fill_gradient2(low = "whitesmoke",  high = "purple", breaks = c(0,0.0045,0.0090))
  
  liana_nichenet <- liana_res %>% filter(target == receiver) %>% left_join(ligand_activities %>% rename(ligand.complex = test_ligand, rank_Nichenet = rank))
  p_liana_nichenet <- liana_nichenet %>% filter(target == receiver & rank_Nichenet <= 30) %>%
    liana_dotplot(target_groups = receiver,
                  ntop = 50) +
    theme(axis.text.x = element_text(angle = 90, 
                                     vjust = 0.5,
                                     hjust= 0.5))
  p_nichenet_liana = liana_nichenet %>% filter(target == receiver & rank_Nichenet <= 30) %>% group_by(ligand.complex) %>% top_n(2, desc(aggregate_rank)) %>%
    liana_dotplot() +
    theme(axis.text.x = element_text(angle = 90, 
                                     vjust = 0.5,
                                     hjust= 0.5))
  
  liana_nichenet <- liana_nichenet %>%
    left_join(DE_table %>% rename(source = contrast, ligand.complex = name,
                                  logFC_ligand = logFCs, 
                                  pval_ligand = pvals)) %>%
    left_join(DE_table %>% rename(target = contrast, receptor.complex = name,
                                  logFC_receptor = logFCs, pval_receptor = pvals))
  
  return(list(liana_nichenet = liana_nichenet,
              p_ligand_expression = p_ligand_expression,
              p_ligand_target_network = p_ligand_target_network,
              p_liana_nichenet = p_liana_nichenet,
              p_nichenet_liana = p_nichenet_liana))
  
}

