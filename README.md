Najprej si na spletni strani: poglej nekaj kratkih tutorialov, da boš lažje razumel Ruby on Rails in MVC sistem.

Ustvari nov projekt. V konzolo napišeš naslednji ukaz, ki bo ustvaril novo rails aplikacijo imenovano Blog.
```
rails new Blog
```

Sedaj se v terminalu prestavi v mapo Blog, da lahko začneš ustvarjati potrebne kontrolerje in modele
```
cd Blog
```

Najprej moraš ustvariti Model. Tega ustvariš tako, da v konzolo vpišeš naslednji ukaz
Pomembno: imena modelov morajo biti v ednini ter se vedno začeti z veliko začetnico

```
rails g model Blog title:text body:string
```

Ta ukaz je ustvaril migracijsko skripto, kamor so se vstavili atributi title vrste text, body vrste string; prav tako
pa se dodajo še trije atributi, ki se ustvarijo sami in sicer: created_at in updated_at, ki sta vrste timestamp ter atribut id.

Takoj potem, ko si ustvaril migracijsko skripto še ta ni uveljavljena v podatkovni bazi. Zato moraš vpisati naslednji ukaz
```
rake db:migrate
```

Tip: Če si se pri ustvarjanju skripte zmotil jo lahko še pred migracijo izbrišeš z ukazom
```
rails destroy migration ImeMigracije
```
Datotek NIKOLI ne briši preko vmesnika ampak vedno preko konzole, prav tako ne briši migracijskih skript, ki so uveljavljene v bazi!!!

Sedaj moraš še ustvariti kontroler, ki bo omogočal komunikacijo med Model in Views. Ustvariš ga z naslednjim ukazom
Pomembno: kontrolerji se vedno začnejo z majhno začetnico, so zapisani v množini, ter imajo ime modela kateremu pripadajo.
```
rails g controller blogs
```
Sedaj ko si ustvaril kontroler lahko vanj zapišemo def-funkcije po CRUD metodi (Create, Read, Update, Destroy). Kontroler najdeš v app/controllers/blog_controller.rb. V kontroler ponavadi
napišemo 7 def in sicer:
    - def index (prikaz splošnih izpisov iz baze)
    - def show (prikaz posameznega izpisa iz baze)
    - def new (ustvari nov prazen objekt, ki ga zapolnimo z create)
    - def create (prej ustvarjen objekt zapolni z podatki iz forma)
    - def edit (ustvari nov objekt, v katerem so podatki za specifični zapis v bazi)
    - def update (posodobi objekt z podatki, ki jih dobi iz forma)
    - def destroy (uniči izbrani objekt)

```
def index
end

def show
end

def new
end

def create
end

def edit
end

def update
end

def destroy
end
```

Sedaj ko si zapisal tek 7 def pa moraš še vsaki povedati kaj mora narediti.
```
class BlogsController < ApplicationController
    # Ker bi moral pri nekaterih def ponavljati isto kodo se moraš držati DRY metode (Don't Repeat Yourself) kar pomeni,
    # da moramo ustvariti skupno funkcijo za te def, ki jo bomo poimenovali find_blog ter jo dodali na koncu. Z ukazom
    # before_action povemo aplikaciji da najprej iti na def find_blog preden gre na ostale vendar le v primeru, ko
    # so izbrane def show, edit, update ali pa destroy

    before_action :find_blog, only: [:show, :edit, :update, :destroy]
```

```
    # Ustvari @blogs spremenljivko, v katero shrani vse zapise iz baze ter jih uredi po datumu nastanka

    def index
        @blogs = Blog.all.order("created_at DESC")
    end
```

```
    # Ustvari nov objekt, ki ga zgradi z uporabnikovim idjem (razlaga kasneje)

    def new
        @blog = current_user.blogs.build
    end
```

```
    # Iz forma, ki ga bomo ustvarili kasneje pridobi podatke ter shrani objekt v bazo.
    # V oklepaju imamo blog_params ki je zopet def in jo uporabljamo zaradi DRY metode.
    # Razlaga spodaj

    def create
        @blog = current_user.blogs.build(blog_params)
        
        if @blog.save
            redirect_to @blog, notice: "New post was created"
        else
            render "new"
        end
    end
```

```
    # Iz forma, ki ga bomo ustvarili kasneje pridobi podatke ter shrani objekt v bazo

    def update
        @blog.update(blog_params)
            redirect_to @blog, notice: "Post was succsessfully"
        else
            render "edit"
        end
    end
```

```
    # Vzame objekt ter ga izbriše iz baze
    def destroy
        @blog.destroy
        redirect_to root_path
    end
```

```
    # Ustvari private del, kamor lahko dostopajo le funkcije iz tega kontrolerja. 

    private
        # def blog_params se uporablja zato, da si uporabnik ne more sam dodati oz. spremeniti polja vnosa v formu
        # ter dovoli zapis le, če so parametri enaki parametrom znotraj .permit() stavka.
        def blog_params
            params.require(:blog).permit(:image, :title, :body)
        end
        # def find_blog uporabljamo zato, da najdemo specifičen izpis s pomočjo id-ja iz URL naslova
        def find_blog
            @blog = Blog.find(params[:id])
        end
```

Sedaj, ko si ustvaril vse potrebne funkcije znotraj kontrolerja pa moraš še aplikaciji povedati, da ta kontroler sploh obstaja.
To narediš tako, da napišeš naslednji del kode v routes.rb datoteko, ki jo najdeš v mapi config/routes.rb
Potrebno je definirati tudi root page oz. prvo stran. Tudi to definiraš znotraj routes.rb datoteke.
```
    resources :blogs
    root "blogs#index"
```


Pri ustvarjanju rails aplikacij si večino časa pomagamo z že prej napisanimi deli imenovanimi GEMS.
To so paketi kode, ki jih je napisala skupnost in delujejo kot razširitve v aplikaciji.
Na spletni strani: www.rubygems.org so shranjeni linki do vseh javno dostopnih GEMov.

Eden od teh je tudi gem imenovan Devise, ki nam omogoča na hiter način postaviti bazo z uporabniki, login/logout forme, registracijske forme in še več.

