from rake_nltk import Rake
import nltk
from nltk.tokenize import word_tokenize, sent_tokenize
from nltk.tag import pos_tag

class TextAnalyzer:

    def extract_key_pharses(self, text):
        r = Rake()
        r.extract_keywords_from_text(text)
        key_phrases = "\n".join(r.get_ranked_phrases())
        return key_phrases[:5]

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
    

