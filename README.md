# bookish-winner

Decidí no usar Pods para intentar recrear tantas funcionalidades como fera posible desde casi cero. Por ejemplo, en una aplicación de producción, muy probablemente usaria AFNetworking para las interacciones con la red. Siendo un ejercicio, me pareció más interesante trabajr con url session.

`NetworkSession` es un protocolo que fácilmente puede ser implementado por la nativa `URLSession`, pero, quizá de manera más interesante, por stubs en tests (on incluso en live, para precargar data). 

Una de las cosas que me parece seria de utilidad en la API es un endpoint para validar el token. 

Core Data es una herramienta que puede ser usada para preservar el grafo de feeds y artculos para visualización offline. Preferí no usarla para preservar ciclos

Obviamente, no hay rastros de diseño. 
