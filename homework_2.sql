--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
select product_id,product_name,s.company_name,s.phone 
from products p
inner join suppliers s on p.supplier_id = s.supplier_id
where units_in_stock=0

--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
select o.ship_address,e.last_name,e.first_name,o.order_date 
from orders o
inner join employees e on o.employee_id=e.employee_id
where extract(month from o.order_date)=3 and extract(year from o.order_date)=1998

--28. 1997 yılı şubat ayında kaç siparişim var?
select count(quantity) 
from order_details od
inner join orders o on od.order_id=o.order_id
where extract(month from o.order_date)=2 and extract(year from o.order_date)=1997

--29. London şehrinden 1998 yılında kaç siparişim var?
select count(quantity) 
from order_details od
inner join orders o on od.order_id=o.order_id
where ship_city ='London' and extract(year from o.order_date)=1998 
 
--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
select c.contact_name,c.phone 
from orders o
inner join customers c on o.customer_id=c.customer_id
where extract(year from o.order_date)=1997

--31. Taşıma ücreti 40 üzeri olan siparişlerim
select * from orders
where freight>40 

--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
select ship_city,c.contact_name,freight 
from orders o
inner join customers c  on o.customer_id=c.customer_id
where freight>40

--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
select order_date,ship_city,concat(upper (first_name),' ',upper(last_name)) 
from orders o
inner join employees e on o.employee_id=e.employee_id
where extract(year from o.order_date) = 1997

--34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
select c.contact_name, REPLACE(REPLACE(REPLACE(REPLACE(c.phone, '(', ''), ')', ''), ' ', ''),'-','')
as telefon
from customers c
inner join orders o on c.customer_id = o.customer_id
where extract(year from o.order_date) = 1997
	
--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
select order_date,contact_name,first_name,last_name 
from orders o
inner join customers c on c.customer_id=o.customer_id
inner join employees e on e.employee_id=o.employee_id

--36. Geciken siparişlerim?
select * from orders 
where shipped_date>required_date

--37. Geciken siparişlerimin tarihi, müşterisinin adı
select shipped_date,contact_name 
from orders o 
inner join customers c on c.customer_id=o.customer_id
where shipped_date>required_date

--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select p.product_name,k.category_name,od.quantity
from orders o
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id = p.product_id
inner join categories k on p.category_id=k.category_id
where o.order_id =10248

--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select p.product_name,s.contact_name
from orders o
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id = p.product_id 
inner join suppliers s on p.supplier_id =s.supplier_id
where o.order_id = 10248

--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select p.product_name,od.quantity
from employees e
inner join orders o on e.employee_id=o.employee_id
inner join order_details od on o.order_id=od.order_id
inner join products p on od.product_id=p.product_id
where e.employee_id = 3 and extract(year from o.order_date)=1997

--41. 1997 yılında bir defasında en çok satış yapan çalışanımın ID,Ad soyad
select e.employee_id,od.order_id,e.first_name,e.last_name,sum(unit_price*quantity) as toplam_satis 
from employees e 
inner join orders o on e.employee_id=o.employee_id
inner join order_details od on od.order_id=o.order_id
where extract(year from o.order_date)=1997
group by od.order_id,e.employee_id,e.first_name,e.last_name
order by 5 desc 
limit 1 ;

--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad **** 
select e.employee_id,e.first_name,e.last_name
from employees e
inner join orders o on e.employee_id=o.employee_id
where extract(year from o.order_date)=1997
group by e.employee_id,e.first_name,e.last_name
order by count(o.order_id) desc
limit 1

--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?--56 ile aynı
select p.product_name, p.unit_price, c.category_name 
from products p
inner join categories c on c.category_id = p.category_id
group by p.product_name, p.unit_price, c.category_name
order by count(p.unit_price) desc
limit 1

--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID.(Sıralama sipariş tarihine göre)
select e.first_name,e.last_name,o.order_date,o.order_id
from orders o
inner join employees e on o.employee_id =e.employee_id
order by o.order_date
 
--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select avg(od.unit_price) as avg_price,o.order_id
from order_details od
inner join orders o on od.order_id=o.order_id
group by o.order_id
order by o.order_date desc
limit 5

--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.product_name,c.category_name,sum(od.quantity) as total_sales
from order_details od
inner join products p on od.product_id=p.product_id
inner join categories c on p.category_id=c.category_id
inner join orders o on od.order_id=o.order_id
where extract(month from o.order_date)=1
group by p.product_name,c.category_name

--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select o.order_id,od.product_id,od.quantity
from order_details od 
inner join orders o on od.order_id=o.order_id
where od.quantity > (select avg(quantity) from order_details)

--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select product_name,category_name,contact_name 
from order_details od 
inner join products p on p.product_id=od.product_id
inner join categories c on p.category_id=c.category_id
inner join suppliers s on s.supplier_id=p.supplier_id
group by product_name,category_name,contact_name
order by sum(quantity) desc 
limit 1

--49. Kaç ülkeden müşterim var?
select count(distinct country) 
from customers

--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select  sum(order_details.quantity) as adet ,employees.first_name as adi, employees.last_name 
as soyadi , employees.employee_id as calisanid
from orders inner join employees  on  employees.employee_id = orders.employee_id
inner join order_details on orders.order_id = order_details.order_id
where employees.employee_id = 3 and order_date >= '1998-01-01' and order_date <= current_date
group by employees.first_name , employees.last_name, employees.employee_id

--51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select p.product_name,c.category_name,od.quantity
from order_details od 
inner join products p on od.product_id=p.product_id
inner join categories c on p.category_id=c.category_id
where od.order_id=10248

--52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
--52. ve 39. soru aynı

--53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
--53. ve 40. soru aynı 

--54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
--54. ve 41. soru aynı

--55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
--55. ve 42. soru aynı

--56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
--56. ve 43. soru aynı

--57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
--57. ve 44. soru aynı

--58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
--58. ve 45. soru aynı

--59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
--59. ve 46. soru aynı

--60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
--60. ve 47. soru aynı

--61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
--61. ve 48. soru aynı

--62. Kaç ülkeden müşterim var
--62. ve 49. soru aynı

--63. Hangi ülkeden kaç müşterimiz var
select country ,count(*) as cust_count
from customers
group by country
order by country

--64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
--64. ve 50.soru aynı

--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
select od.product_id,sum(od.quantity * od.unit_price) as total_ciro 
from order_details od
inner join orders o on od.order_id = o.order_id
where od.product_id=10 and order_date between '1998.02.06' and '1998.05.06' 
group By od.product_id

--66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
select employee_id,count(order_id) 
from orders
group by employee_id

--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
select c.company_name,o.order_id 
from customers c 
left join orders o on c.customer_id=o.customer_id
where order_id is null;

--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
select company_name,contact_name,address,city,country
from customers
where country ='Brazil'

--69. Brezilya’da olmayan müşteriler
select company_name,contact_name,address,city,country
from customers
where country !='Brazil'

--70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
--1.yol
select company_name,contact_name,address,city,country
from customers
where country in ('Spain','France','Germany')

--2.yol
select * from customers
where country='Spain' or country='France' or country='Germany'

--71. Faks numarasını bilmediğim müşteriler
--1.yol
select company_name,contact_name,address,city,country
from customers
where fax is null

--2.yol
select * from customers
where fax is null

--72. Londra’da ya da Paris’de bulunan müşterilerim
select * from customers
where city in ('London','Paris')

--73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
select company_name,contact_name,contact_title
from customers
where city=('Mexico D.F.') and contact_title='owner'

--74. C ile başlayan ürünlerimin isimleri ve fiyatları
select product_name,unit_price
from products
where product_name like 'c%'

--75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
select first_name,last_name,birth_date
from employees
where first_name like 'A%'

--76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
select company_name
from customers 
where company_name like '%RESTAURANT%'

--77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
select product_name,unit_price
from products
where unit_price between 50 and 100

--78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
select order_id,order_date
from orders
where order_date between '01-07-1996' and '31-12-1996'

--79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
--79. ve 70. soru aynı

--80. Faks numarasını bilmediğim müşteriler
--80. ve 71. soru aynı

--81. Müşterilerimi ülkeye göre sıralıyorum
select * from customers
order by country

--82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name,unit_price
from products
order by unit_price desc

--83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name,unit_price,units_in_stock
from products 
order by units_in_stock asc,unit_price desc

--84. 1 Numaralı kategoride kaç ürün vardır..?
select p.product_name,c.category_id
from products p
inner join categories c on p.category_id=c.category_id
where c.category_id = 1

--85. Kaç farklı ülkeye ihracat yapıyorum..?
select count(distinct Country) from Customers
