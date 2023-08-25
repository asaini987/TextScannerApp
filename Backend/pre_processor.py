import re
from nltk.tokenize import word_tokenize, sent_tokenize
from nltk.stem import WordNetLemmatizer
from nltk.corpus import stopwords, wordnet
from nltk import pos_tag
from samples import test_text

class PreProcessor:
    def __init__(self, text):
        self.tokenized_sentences = sent_tokenize(text)
        self.num_sents = len(self.tokenized_sentences)
        self._lemmatizer = WordNetLemmatizer()

    def process_sentences(self):
        #cleaning each tokenized sentence of non alphanumeric characters and tokenizing to words
        cleaned_sentences = [re.sub(r"[^\w\s]", "", sentence) for sentence in self.tokenized_sentences]
        tokenized_word_sentences = [word_tokenize(sentence) for sentence in cleaned_sentences]

        processed_sentences = []
        stop_words = set(stopwords.words("english"))

        #filtering each sentence of stopwords and lemmatizing each relevant word
        for word_sentence in tokenized_word_sentences:
            filtered_sentence = []
            for word in word_sentence:
                if word not in stop_words:
                    processed_word = self._get_lemma(word)
                    filtered_sentence.append(processed_word)
            processed_sentences.append(" ".join(filtered_sentence))

        return processed_sentences

    #mapping wordnet tag to nltk tag and returns a lemmatized and lowercased version of the word
    def _get_lemma(self, word):
        tag = pos_tag([word])[0][1]

        if tag.startswith("N"):
            mapped_tag = wordnet.NOUN
        elif tag.startswith("V"):
            mapped_tag = wordnet.VERB
        elif tag.startswith("J"):
            mapped_tag = wordnet.ADJ
        elif tag.startswith("R"):
            mapped_tag = wordnet.ADV
        else:
            mapped_tag = None

        if mapped_tag:
            new_word = self._lemmatizer.lemmatize(word, pos=mapped_tag).lower()
            return new_word
        else:
            return word.lower()
    

    

if __name__ == "__main__":
    processor = PreProcessor(test_text)
