from django.db import models

# Create your models here.

class Product(models.Model):
	product_id = models.AutoField
	product_name = models.CharField(max_length = 300)
	category = models.CharField(max_length = 200, default = "")
	subcategory = models.CharField(max_length = 300, default = "")
	price = models.IntegerField(default = 0)
	prod_desc = models.CharField(max_length = 12000)
	pub_date = models.DateField()
	image = models.ImageField(upload_to = "shop/images", default = "")

	def __str__(self):
		return self.product_name