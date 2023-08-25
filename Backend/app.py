from flask import Flask, jsonify, request
from newspaper import Article
from text_summarizer import TextSummarizer
from text_analyzer import TextAnalyzer

app = Flask(__name__)
text_summarizer = TextSummarizer()
text_analyzer = TextAnalyzer()

@app.route("/summarize", methods=["POST"]) 
def summarize_text():
    data = request.json
    text = data.get("text")
    summary = text_summarizer.summarize(text)
    return jsonify({"summary" : summary})

@app.route("/extract_text", methods=["POST"])
def extract_from_url():
    data = request.json
    url = data.get("url")
    article = Article(url)
    article.download()
    article.parse()
    return jsonify({"text" : article.text})

@app.route("/extract_key_phrases", methods=["POST"])
def get_key_phrases():
    data = request.json
    text = data.get("text")
    key_phrases = text_analyzer.extract_key_pharses(text)
    return key_phrases

@app.route("/named_entities", methods=["POST"])
def named_entity_recog():
    data = request.json
    text = data.get("text")
    named_ents = "\n".join(text_analyzer.name_entities(text))
    return named_ents

if __name__ == "__main__":
    app.run(debug=True)
