enum OrderStatus {
  concluido,
  emAndamento,
  cancelado,
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.concluido:
        return 'Concluído';
      case OrderStatus.emAndamento:
        return 'Em andamento';
      case OrderStatus.cancelado:
        return 'Cancelado';
    }
  }

  static OrderStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'concluído':
      case 'concluido':
        return OrderStatus.concluido;
      case 'em andamento':
        return OrderStatus.emAndamento;
      case 'cancelado':
        return OrderStatus.cancelado;
      default:
        return OrderStatus.concluido; // padrão
    }
  }
}
