import nltk
from rake_nltk import Rake
from nltk.tokenize import word_tokenize, sent_tokenize
from nltk.tag import pos_tag

class TextAnalyzer:

    def extract_key_phrases(self, text):
        r = Rake()
        r.extract_keywords_from_text(text)
        all_key_phrases = r.get_ranked_phrases()
        key_phrases = "\n".join(all_key_phrases[:5])
        return key_phrases

    def name_entities(self, text):
        tokenized_sentences = sent_tokenize(text)

        for sentence in tokenized_sentences:
            words = word_tokenize(sentence)
            tagged = pos_tag(words)
            named_ent = nltk.ne_chunk(tagged)

            all_named_entities = []
            for entity in named_ent:
                if isinstance(entity, nltk.Tree):
                    label = entity.label()
                    entity_text = " ".join([word for word, _ in entity.leaves()])
                    all_named_entities.append(f"{entity_text} {label}")
        
        return all_named_entities
