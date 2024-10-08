
# TIME MANAGER

 Gotham City Hall wants to deploy the application on several platforms (mainly computers and different types of terminals). It is also considering a mobile version.
 The goal of this project is to create a platform-independent API for exchanging and storing data.


## Tech Stack

**Server:** Elixir

**Frame work:** Phoenix


## Installation

### You need :
- [``Erlang VM``](https://www.erlang.org/downloads.html)
- [`Elixir`](https://elixir-lang.org/install.html) 
- [``Phoenix FrameWork``](https://hexdocs.pm/phoenix/up_and_running.html)
- [``Docker``](https://www.docker.com/products/docker-desktop/)

    


Clone the project :

```bash
  git clone https://github.com/EpitechMscProPromo2026/T-POO-700-LIL_2
```

Go to the project directory :

```bash
  cd T-POO-700-LIL_2
```
Run docker Compose to get the workspace :

```bash
  docker compose up -d
```

To add the dependencies run :
```bash
  mix deps.get
```

To create the database run :

```bash
  mix ecto.create  
```

To migrate the database run :

```bash
  mix ecto.migrate
```


To start the Phoenix server:
```bash
  mix phx.server 
```
Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## API Reference

#### SWAGGER

To check the API Reference you can visit [`the swagger`](http://localhost:4000/api/swagger) from your browser.


## Running Tests

To run tests, run the following command

```bash
  mix test
```






## Authors

- [🦍@Tiagovhs🐉](https://github.com/Tiagovhs)
- [@Natchii59](https://github.com/Natchii59)
- [@BryanFRD](https://github.com/BryanFRD)
- [@Sarah](https://github.com/dumbfacemonster)
