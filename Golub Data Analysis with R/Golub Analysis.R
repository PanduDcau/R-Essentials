#Installing BiocManager:: for the Data Extraction
#if (!require("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install()

#library Installato
BiocManager::install("multtest")
BiocManager::install("pheatmap")
library(multtest)
BiocManager::install("factoextra")
library(factoextra)
library(pheatmap)

#Data Acquisition
data(golub)

# View the dimensions of the dataset
dim(golub)

#Getting the Summery of the Golub Dataset
summary(golub)

golubTranspose <- t(golub)

pheatmap(golubTranspose, scale = "row")

######################### Hierarchical clustering ########################

# Complete Hierarchical Clustering using Pearson's correlation matrix
pearsonCorrDist <- get_dist(golubTranspose, stand = TRUE, method = "pearson")
# distance matrix - Pearson's correlation distance
fitPearsonCorr <- hclust(pearsonCorrDist, method = "complete")

#plotting Pearson Correlation
plot(fitPearsonCorr,main = "Person's Correlation Distance Tree")
# cut tree into 2 clusters
groupsPearsonCorr <- cutree(fitPearsonCorr, k = 2)
# draw Dendrogram with red borders around the 2 clusters
rect.hclust(fitPearsonCorr, k = 2, border = "red")

# Complete Hierarchical Clustering using Euclidean distance
euclideanDist <- get_dist(golubTranspose, stand = TRUE, method = "euclidean")
# distance matrix - Euclidean distance
fitEuclidean <- hclust(euclideanDist, method = "complete")
#fitEuclidean <- hclust(euclideanDist, method = "ward.D2")

#Plotting Euclidean Distance in Hierarchical Clustering
plot(fitEuclidean,main = "Euclidean Distance Tree")

# cut tree into 2 clusters
groupsEuclidean <- cutree(fitEuclidean, k = 2)
# draw dendogram with red borders around the 2 clusters
rect.hclust(fitEuclidean, k = 2, border = "red")

# Compare the two trees visually to see if there are any differences in the clustering patterns.
#par(mfrow = c(1,2))
plot(fitPearsonCorr,main = "Person's Correlation Distance Tree")
plot(fitEuclidean,main = "Euclidean Distance Tree")

########################### K-Means clustering ##########################
# K-Means Cluster Analysis
fitKMeans <- eclust(golubTranspose, "kmeans", k = 2, stand=TRUE)

#exprs <- golub$Y
labels <- golub.cl
golub.cl

kmeans_res <- kmeans(golubTranspose, nstart = 25, centers = 2)

pheatmap(golubTranspose, cluster_rows = FALSE, cluster_cols = FALSE,
         col = colorRampPalette(c("blue", "white", "red"))(100),
         breaks = seq(-3, 3, length.out = 101))

######## Creating K=2 Clusters From Kmeans Clustering Algorithm
k <- 2

# Run the K-means algorithm using the selected subset of genes and the chosen value of k.
kmeans_result <- kmeans(golub, centers = k, nstart = 25)

# Examine the resulting clusters and the cluster centers.
kmeans_result$cluster
kmeans_result$centers

# Print the cluster centers
kmeans_result$centers

# Print the size of each cluster
table(kmeans_result$cluster)

# Get the cluster label
cluster_labels <- as.factor(kmeans_result$cluster)

# Visualize the clusters
fviz_cluster(list(data = golub, cluster = cluster_labels))

##################Confusion Matrix for Both Clustering Mechanisms#######
# Compute distance matrices
dist_pearson <- 1 - cor(t(golubTranspose), method = "pearson")
dist_euclidean <- dist(t(golubTranspose), method = "euclidean")

# Hierarchical clustering with Pearson correlation
hc_pearson <- hclust(as.dist(dist_pearson), method = "complete")
cutree_pearson <- cutree(hc_pearson, k = 2)

# Hierarchical clustering with Euclidean distance
hc_euclidean <- hclust(dist_euclidean, method = "complete")
cutree_euclidean <- cutree(hc_euclidean, k = 2)

# Confusion matrix for Pearson correlation
confusion_pearson <- table(cutree_pearson, labels)
cat("Confusion matrix for Pearson correlation:\n")
print(confusion_pearson)


# Extract predicted cluster assignments
pred_clusters <- kmeans_res$cluster

# Create confusion matrix
conf_matrix <- table(pred_clusters, golub.cl)
colnames(conf_matrix) <- c("AML", "ALL")
rownames(conf_matrix) <- c("Cluster 1", "Cluster 2")
conf_matrix

# Confusion matrix for Euclidean distance
#confusion_euclidean <- table(cutree_euclidean, labels)
#cat("Confusion matrix for Euclidean distance:\n")
#print(confusion_euclidean)


#################### Comparing Clusters Similarity#######################
#Clustering done for the Comparison
library(cluster)
#Mclust library used for cluster similarity checking
library(mclust)
ari_hc <- adjustedRandIndex(labels, cutree(fitPearsonCorr, k = 2))
ari_eu <- adjustedRandIndex(labels, cutree(fitEuclidean, k = 2))
ari_kmeans <- adjustedRandIndex(labels, kmeans_res$cluster)

#ARI stands for Adjusted Rand Index.
#It is a measure of similarity between two clustering results
cat("ARI for hierarchical Pearson clustering:", round(ari_hc, 4), "\n")
cat("ARI for hierarchical Euclidean clustering:", round(ari_eu, 4), "\n")
cat("ARI for k-means clustering:", round(ari_kmeans, 4), "\n")

