# app.py
from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__, template_folder='templates')

# Sample ferry routes data with image paths
ferry_routes = [
    {"id": 1, "destination": "Island A", "price": 25.00, "departure": "10:00 AM", "image": "ferry_a.jpg"},
    {"id": 2, "destination": "Island B", "price": 30.00, "departure": "2:00 PM", "image": "ferry_b.jpg"},
    {"id": 3, "destination": "Island C", "price": 35.00, "departure": "6:00 PM", "image": "ferry_c.jpg"},
    {"id": 4, "destination": "Island D", "price": 28.00, "departure": "9:30 AM", "image": "ferry_d.jpg"}
]

@app.route('/')
def home():
    return render_template('home.html', routes=ferry_routes)

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/ticket/<int:route_id>')
def ticket(route_id):
    route = next((r for r in ferry_routes if r['id'] == route_id), None)
    if route:
        return render_template('ticket.html', route=route)
    return "Route not found", 404

@app.route('/checkout/<int:route_id>', methods=['GET', 'POST'])
def checkout(route_id):
    route = next((r for r in ferry_routes if r['id'] == route_id), None)
    if not route:
        return "Route not found", 404

    # Get the number of passengers from the query parameter (default to 1 if not provided)
    passengers = int(request.args.get('passengers', 1))
    # Calculate the total price based on the number of passengers
    total_price = route['price'] * passengers

    if request.method == 'POST':
        # Extract passenger details from the form
        passenger_name = request.form.get('name')
        passenger_email = request.form.get('email')
        # In a real app, you'd process payment here and save the booking to a database
        # Redirect to the order complete page with the booking details
        return redirect(url_for('order_complete',
                               route_id=route['id'],
                               passengers=passengers,
                               total_price=total_price,
                               passenger_name=passenger_name,
                               passenger_email=passenger_email))

    return render_template('checkout.html', route=route, passengers=passengers, total_price=total_price)

@app.route('/order_complete/<int:route_id>')
def order_complete(route_id):
    route = next((r for r in ferry_routes if r['id'] == route_id), None)
    if not route:
        return "Route not found", 404

    # Get the booking details from the query parameters
    passengers = int(request.args.get('passengers', 1))
    total_price = float(request.args.get('total_price', 0))
    passenger_name = request.args.get('passenger_name', 'Unknown')
    passenger_email = request.args.get('passenger_email', 'Unknown')

    return render_template('order_complete.html',
                          route=route,
                          passengers=passengers,
                          total_price=total_price,
                          passenger_name=passenger_name,
                          passenger_email=passenger_email)

if __name__ == '__main__':
    app.run(port=5050)