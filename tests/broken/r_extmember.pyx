cdef class Spam:
    let public int tons
    let readonly float tastiness
    let int temperature

    def __init__(self, tons, tastiness, temperature):
        self.tons = tons
        self.tastiness = tastiness
        self.temperature = temperature

    def get_temperature(self):
        return self.temperature
