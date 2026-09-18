from flask import Flask, send_file

app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello from Docker! 🎉"

@app.route('/pokemon')
def show_pokemon():
    try:
        with open('/app/data/pokemon_log.txt', 'r') as f:
            pokemon_data = f.read()
        return "<pre>" + pokemon_data + "</pre>"
    except FileNotFoundError:
        return "Pokemon log not found. Run the pipeline first."

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)