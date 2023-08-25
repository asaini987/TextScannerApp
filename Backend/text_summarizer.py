import numpy as np
import networkx as nx
from sentence_transformers import SentenceTransformer
from scipy.spatial.distance import cosine
from pre_processor import PreProcessor

class TextSummarizer:
    def __init__(self):
        self._model = SentenceTransformer("sentence-transformers/sentence-t5-base")
        
    def summarize(self, text):
        #pre-processing the text and embedding sentences using T5 sentence transformer model
        processor = PreProcessor(text)
        processed_sentences = processor.process_sentences()
        sentence_embeddings = self._model.encode(processed_sentences)

        #building similarity matrix and calculating the cosine distance between each pair of vectors
        similarity_matrix = np.zeros((processor.num_sents, processor.num_sents))

        for x in range(processor.num_sents):
            for y in range(processor.num_sents):
                if x != y:
                    similarity_matrix[x][y] = 1 - (cosine(sentence_embeddings[x], sentence_embeddings[y]))

        #creating graph and applying PageRank algorithm
        graph = nx.from_numpy_array(similarity_matrix)
        ranks = nx.pagerank(graph)

        #sorting top ranked sentences and joining the first few sentences to return a summary
        scores = [(sent_num, rank) for sent_num,rank in ranks.items()]
        ranked_scores = sorted(scores, key = lambda x: x[1], reverse = True)

        sum_length = self._calculate_sum_length(processor.num_sents)
        sum_sents = [processor.tokenized_sentences[ranked_scores[i][0]] for i in range(sum_length)]
        summary = " ".join(sum_sents)

        return summary
    
    #calculates length of summary based on how many sentences were in the provided text
    def _calculate_sum_length(self, text_length):
        if text_length <= 10:
            return text_length // 2
        elif text_length > 10 and text_length < 13:
            return 5
        elif text_length >= 13 and text_length < 16:
            return 6
        elif text_length >= 16 and text_length < 20:
            return 7
        elif text_length >= 20 and text_length < 30:
            return 8
        else:
            return 10
