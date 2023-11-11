--86. a.Bu ülkeler hangileri..?
select distinct ship_country 
from customers

--87. En Pahalı 5 ürün
select * from products
order by unit_price desc
limit 5

--88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?
select customer_id, sum(quantity) 
from orders o
inner join order_details od on od.order_id =o.order_id
where customer_id= 'ALFKI'
group by customer_id

--89. Ürünlerimin toplam maliyeti
select sum((units_on_order+units_in_stock)*unit_price)
from products

--90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?
select sum((unit_price*quantity)*(1-discount)) as ciro
from order_details

--91. Ortalama Ürün Fiyatım
select avg(unit_price) from products

--92. En Pahalı Ürünün Adı
select product_name, unit_price
from products 
order by unit_price desc
limit 1

--93. En az kazandıran sipariş
select order_id,sum(unit_price*quantity) as dusuk_kazanc
from order_details
group by order_id
order by dusuk_kazanc asc
limit 1

--94. Müşterilerimin içinde en uzun isimli müşteri
select company_name,length(company_name) 
from customers
order by length(company_name) desc
limit 1

--95. Çalışanlarımın Ad, Soyad ve Yaşları
select last_name, first_name, DATE_PART('year', AGE(current_date, birth_date)) as age 
from employees

--96. Hangi üründen toplam kaç adet alınmış..?
select order_id, sum(quantity) as toplam_urun
from order_details
group by order_id
order by toplam_urun desc

--97. Hangi siparişte toplam ne kadar kazanmışım..?
select  order_id, sum(quantity*unit_price) as toplam_kazanc
from order_details
group by order_id
order by order_id desc

--98. Hangi kategoride toplam kaç adet ürün bulunuyor..?
select category_id, count(category_id) as toplam_urun
from products
group by category_id

--99. 1000 Adetten fazla satılan ürünler?
select p.product_id,p.product_name, sum(quantity) as satilan
from order_details od
join products p on od.product_id=p.product_id
group by p.product_id,p.product_name
having sum(quantity) > 1000
order by satilan desc

--100. Hangi Müşterilerim hiç sipariş vermemiş..?
select c.customer_id,c.company_name
from customers c
left join orders o on c.customer_id=o.customer_id
where o.order_id is null

--101. Hangi tedarikçi hangi ürünü sağlıyor ?
select p.product_name,s.company_name
from products p
join suppliers s on p.supplier_id=s.supplier_id
order by product_name asc

--102. Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?
select o.order_id,s.company_name,o.shipped_date
from orders o
inner join shippers s on s.shipper_id=o.ship_via

--103. Hangi siparişi hangi müşteri verir..?
select o.order_id,c.customer_id,c.company_name
from orders o
inner join customers c on o.customer_id=c.customer_id

--104. Hangi çalışan, toplam kaç sipariş almış..?
select e.employee_id,first_name,last_name,count(o.order_id) as toplam_siparis
from employees e
left join orders o on e.employee_id=o.employee_id
group by e.employee_id,first_name,last_name

--105. En fazla siparişi kim almış..?
select e.employee_id,first_name,last_name,count(o.order_id) as toplam_siparis
from employees e
left join orders o on e.employee_id=o.employee_id
group by e.employee_id,first_name,last_name
order by toplam_siparis desc
limit 1

--106. Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?
select o.order_id,e.employee_id,c.customer_id
from orders o
inner join employees e on o.employee_id=e.employee_id
inner join customers c on o.customer_id=c.customer_id

--107. Hangi ürün, hangi kategoride bulunmaktadır..? Bu ürünü kim tedarik etmektedir..?
select p.product_id,p.product_name,c.category_id,c.category_name,s.supplier_id,s.company_name
from products p
inner join categories c on p.category_id=c.category_id
inner join suppliers s on p.supplier_id=s.supplier_id

--108. Hangi siparişi hangi müşteri vermiş, hangi çalışan almış, hangi tarihte,
--hangi kargo şirketi tarafından gönderilmiş hangi üründen kaç adet alınmış, hangi fiyattan alınmış,
--ürün hangi kategorideymiş bu ürünü hangi tedarikçi sağlamış
select o.order_id,c.company_name,e.first_name,e.last_name,o.order_date,s.company_name,
       p.product_name,k.category_name,sp.company_name,od.unit_price,od.quantity
from orders o
inner join customers c on o.customer_id=c.customer_id
inner join employees e on o.employee_id=e.employee_id
inner join shippers s on o.ship_via=s.shipper_id
inner join order_details od on o.order_id=od.order_id
inner join products p on od.product_id=p.product_id
inner join categories k on p.category_id=k.category_id
inner join suppliers sp on p.supplier_id=sp.supplier_id
order by o.order_id asc 

--109. Altında ürün bulunmayan kategoriler
select c.category_id,c.category_name,p.product_name
from categories c
inner join products p on c.category_id=p.category_id
where p.product_id is null

--110. Manager ünvanına sahip tüm müşterileri listeleyiniz.
select customer_id,company_name,contact_name,contact_title
from customers 
where contact_title like '%Manager'

--111. FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.
select customer_id
from customers
where customer_id like 'FR___'

--112. (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.
select customer_id,contact_name,phone
from customers
where phone like '(171)%'

--113. Birimdeki Miktar alanında boxes geçen tüm ürünleri listeleyiniz.
select product_id,quantity_per_unit
from products
where quantity_per_unit like '%boxes%'

--114. Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)
select country, phone, company_name , contact_title 
from customers 
where country in ('France' , 'Germany') and contact_title like '%Manager%'

--115. En yüksek birim fiyata sahip 10 ürünü listeleyiniz.
select max(unit_price)
from products 
group by unit_price
order by unit_price desc
limit 10

--116. Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.
select customer_id,company_name,country,city
from customers
order by country,city

--117. Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.
--117. ve 95. soru aynı

--118. 35 gün içinde sevk edilmeyen satışları listeleyiniz.
select order_id , customer_id , order_date, shipped_date
from orders 
where shipped_date is null and (current_date - order_date) > 35

--119. Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)
select category_name
from categories
where category_id in (select category_id from products where unit_price = 
					 (select max(unit_price) from products))

--120. Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)
select category_name
from categories
where category_id in (select category_id from categories where category_name like '%on%')

--121. Konbu adlı üründen kaç adet satılmıştır.
select sum(quantity) as total_konbu
from order_details
where product_id in (select product_id from products where product_name = 'Konbu')

--122. Japonyadan kaç farklı ürün tedarik edilmektedir.
select count(distinct product_id) as farkli_urun
from products
where supplier_id in (select supplier_id from suppliers where country = 'Japan')

--123. 1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücretlisi ne kadardır?
select max(freight),min(freight),avg(freight)
from orders
where extract (year from order_date) = 1997

--124. Faks numarası olan tüm müşterileri listeleyiniz.
select *from customers 
where fax is not null

--125. 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz. 
select order_id,customer_id,order_date,shipped_date
from orders
where shipped_date between '1996-07-16' and '1996-07-30'
